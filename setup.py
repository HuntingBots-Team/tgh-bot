from setuptools import setup, find_packages

setup(
    name="tghbot",
    version="1.0.0",
    packages=find_packages(),
    package_data={
        'tghbot': ['plugins/*', 'plugins/myjd/*'],
    },
    install_requires=[
        "telegraph",
        "pyrogram",
        "tgcrypto",
        "aiofiles",
        "httpx",
    ],
)