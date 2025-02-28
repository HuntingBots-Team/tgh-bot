from httpx import (
    AsyncClient,
    DecodingError,
    AsyncHTTPTransport,
    Timeout
)
from urllib3 import disable_warnings
from urllib3.exceptions import InsecureRequestWarning
from functools import wraps

from sabnzbdapi.job_functions import JobFunctions
from sabnzbdapi.exception import APIConnectionError


class SabnzbdSession(AsyncClient):
    @wraps(AsyncClient.request)
    async def request(
        self,
        method: str,
        url: str,
        **kwargs
    ):
        kwargs.setdefault(
            "timeout",
            Timeout(
                connect=30,
                read=60,
                write=60,
                pool=None
            )
        )
        kwargs.setdefault(
            "follow_redirects",
            True
        )
        return await super().request(
            method,
            url,
            **kwargs
        )


class SabnzbdClient(JobFunctions):

    LOGGED_IN = False

    def __init__(
        self,
        host: str,
        api_key: str,
        port: str = "8070",
        VERIFY_CERTIFICATE: bool = False,
        RETRIES: int = 10,
        HTTPX_REQUETS_ARGS: dict = None, # type: ignore
    ):
        if HTTPX_REQUETS_ARGS is None:
            HTTPX_REQUETS_ARGS = {}
        self._base_url = f"{host.rstrip('/')}:{port}/sabnzbd/api"
        self._default_params = {
            "apikey": api_key,
            "output": "json"
        }
        self._VERIFY_CERTIFICATE = VERIFY_CERTIFICATE
        self._RETRIES = RETRIES
        self._HTTPX_REQUETS_ARGS = HTTPX_REQUETS_ARGS
        self._http_session = None
        if not self._VERIFY_CERTIFICATE:
            disable_warnings(InsecureRequestWarning)
        super().__init__()

    def _session(self):
        if self._http_session is not None:
            return self._http_session

        transport = AsyncHTTPTransport(
            retries=self._RETRIES,
            verify=self._VERIFY_CERTIFICATE
        )

        self._http_session = SabnzbdSession(transport=transport)

        self._http_session.verify = self._VERIFY_CERTIFICATE

        return self._http_session

    async def call(
        self,
        params: dict = None, # type: ignore
        api_method: str = "GET",
        requests_args: dict = None, # type: ignore
        **kwargs,
    ):
        if requests_args is None:
            requests_args = {}
        session = self._session()
        params |= kwargs
        requests_kwargs = {
            **self._HTTPX_REQUETS_ARGS,
            **requests_args
        }
        retries = 5
        response = None
        params = params or {}
        for retry_count in range(retries):
            try:
                res = await session.request(
                    method=api_method,
                    url=self._base_url,
                    params={
                        **self._default_params,
                        **params
                    },
                    **requests_kwargs,
                )
                
                # Check HTTP status code
                if res.status_code != 200:
                    raise APIConnectionError(
                        f"API returned unexpected status {res.status_code}. Response: {res.text}"
                    )
                
                # Verify JSON content type
                content_type = res.headers.get("Content-Type", "")
                if "application/json" not in content_type:
                    raise DecodingError(
                        f"Unexpected Content-Type '{content_type}'. Response: {res.text}"
                    )
                
                # Parse JSON with explicit error handling
                try:
                    response = res.json()
                except JSONDecodeError as e:
                    raise DecodingError(
                        f"Failed to parse JSON response: {e}\nResponse text: {res.text}"
                    ) from e
                    
                break
            except (DecodingError, JSONDecodeError) as e:
                if retry_count >= (retries - 1):
                    raise APIConnectionError(
                        f"Final retry failed after {retries} attempts. Last error: {str(e)}"
                    ) from e
        if response is None:
            raise APIConnectionError("Failed to connect to API!")
        return response

    async def log_out(self):
        if self._http_session is not None:
            await self._http_session.aclose()
            self._http_session = None
