from sabnzbdapi.bound_methods import SubFunctions

class JobFunctions(SubFunctions):

    def __init__(self):
        pass

    async def add_uri(
        self,
        url: str = "",
        file: str = "",
        nzbname: str = "",
        password: str = "",
        cat: str = "*",
        script: list = None, # type: ignore
        priority: int = 0,
        pp: int = 1,
    ):

        'return {"status": True, "nzo_ids": ["SABnzbd_nzo_kyt1f0"]}'

        if file:
            name = file
            mode = "addlocalfile"
        else:
            name = url
            mode = "addurl"

        return await self.call( # type: ignore
            {
                "mode": mode,
                "name": name,
                "nzbname": nzbname,
                "password": password,
                "cat": cat,
                "script": script,
                "priority": priority,
                "pp": pp,
            }
        )

    async def get_downloads(
        self,
        start: int | None = None,
        limit: int | None = None,
        search: str | None = None,
        category: str | list[str] | None = None,
        priority: int | list[str] | None = None,
        status: str | list[str] | None = None,
        nzo_ids: str | list[str] | None = None,
    ):
        # Method implementation
        pass

    async def pause_job(self, nzo_id: str):
        """return {"status": True, "nzo_ids": ["all effected ids"]}"""
        return await self.call( # type: ignore
            {
                "mode": "queue",
                "name": "pause",
                "value": nzo_id
            }
        )

    async def resume_job(self, nzo_id: str):
        """return {"status": True, "nzo_ids": ["all effected ids"]}"""
        return await self.call( # type: ignore
            {
                "mode": "queue",
                "name": "resume",
                "value": nzo_id
            }
        )

    async def delete_job(self, nzo_id: str | list[str], delete_files: bool = False):
        """return {"status": True, "nzo_ids": ["all effected ids"]}"""
        return await self.call( # type: ignore
            {
                "mode": "queue",
                "name": "delete",
                "value": (
                    nzo_id
                    if isinstance(
                        nzo_id,
                        str
                    )
                    else ",".join(nzo_id)
                ),
                "del_files": (
                    1
                    if delete_files
                    else 0
                ),
            }
        )

    async def pause_all(self):
        """return {"status": True}"""
        return await self.call({"mode": "pause"}) # type: ignore

    async def resume_all(self):
        """return {"status": True}"""
        return await self.call({"mode": "resume"}) # type: ignore

    async def purge_all(self, delete_files: bool = False):
        """return {"status": True, "nzo_ids": ["all effected ids"]}"""
        return await self.call( # type: ignore
            {
                "mode": "queue",
                "name": "purge",
                "del_files": (
                    1
                    if delete_files
                    else 0
                )
            }
        )

    async def get_files(self, nzo_id: str):
        # Method implementation
        pass

    async def remove_file(self, nzo_id: str, file_ids: str | list[str]):
        return await self.call( # type: ignore
            {
                "mode": "queue",
                "name": "delete_nzf",
                "value": nzo_id,
                "value2": (
                    file_ids
                    if isinstance(
                        file_ids,
                        str
                    ) else ",".join(file_ids)
                ),
            }
        )

    async def get_history(
        self,
        start: int | None = None,
        limit: int | None = None,
        search: str | None = None,
        category: str | list[str] | None = None,
        archive: int | None = None,
        status: str | list[str] | None = None,
        nzo_ids: str | list[str] | None = None,
        failed_only: bool = False,
        last_history_update: int | None = None,
    ):
        # Method implementation
        pass

    async def retry_item(self, nzo_id: str, password: str = ""):
        """return {"status": True}"""
        return await self.call( # type: ignore
            {
                "mode": "retry",
                "value": nzo_id,
                "password": password
            }
        )

    async def retry_all(self):
        """return {"status": True}"""
        return await self.call({"mode": "retry_all"}) # type: ignore

    async def delete_history(
        self, nzo_ids: str | list[str], archive: int = 0, delete_files: bool = False
    ):
        """return {"status": True}"""
        return await self.call( # type: ignore
            {
                "mode": "history",
                "name": "delete",
                "value": (
                    nzo_ids
                    if isinstance(
                        nzo_ids,
                        str
                    )
                    else ",".join(nzo_ids)
                ),
                "archive": archive,
                "del_files": (
                    1
                    if delete_files
                    else 0
                ),
            }
        )

    async def change_job_pp(self, nzo_id: str, pp: int):
        """return {"status": True}"""
        return await self.call( # type: ignore
            {
                "mode": "change_opts",
                "value": nzo_id,
                "value2": pp
            }
        )

    async def set_speedlimit(self, limit: str | int):
        """return {"status": True}"""
        return await self.call( # type: ignore
            {
                "mode": "config",
                "name": "speedlimit",
                "value": limit
            }
        )

    async def delete_config(self, section: str, keyword: str):
        """return {"status": True}"""
        return await self.call( # type: ignore
            {
                "mode": "del_config",
                "section": section,
                "keyword": keyword
            }
        )

    async def set_config_default(self, keyword: str | list[str]):
        """return {"status": True}"""
        return await self.call( # type: ignore
            {
                "mode": "set_config_default",
                "keyword": keyword
            }
        )

    async def get_config(self, section: str = None, keyword: str = None): # type: ignore
        """return config as dic"""
        response = await self.call( # type: ignore
            {
                "mode": "get_config",
                "section": section,
                "keyword": keyword
            }
        )
        print("API Response:", response)
        return response

    async def set_config(self, section: str, keyword: str, value: str):
        """Returns the new setting when saved successfully"""
        return await self.call( # type: ignore
            {
                "mode": "set_config",
                "section": section,
                "keyword": keyword,
                "value": value,
            }
        )

    async def set_special_config(self, section: str, items: dict):
        """Returns the new setting when saved successfully"""
        return await self.call( # type: ignore
            {
                "mode": "set_config",
                "section": section,
                **items,
            }
        )

    async def server_stats(self):
        # Method implementation
        pass

    async def version(self):
        """return {'version': '4.2.2'}"""
        return await self.call({"mode": "version"}) # type: ignore

    def get_version(self):
        return {'version': '4.2.2'}

    async def restart(self):
        """return {"status": True}"""
        return await self.call({"mode": "restart"}) # type: ignore

    async def restart_repair(self):
        """return {"status": True}"""
        return await self.call({"mode": "restart_repair"}) # type: ignore

    async def shutdown(self):
        """return {"status": True}"""
        return await self.call({"mode": "shutdown"}) # type: ignore
