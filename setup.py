from setuptools import setup

try:
    with open("README.rst") as f:
        long_description = f.read()
except OSError:
    long_description = ""

setup(
    # Metadata
    name="JSON_minify",
    version="0.3.0",
    description=(
        "A simple script to minify valid JSON, containing C/C++ style comments"
    ),
    long_description=long_description,
    url="https://github.com/getify/JSON.minify/tree/python",
    author="Gerald Storer",

    maintainer="Pradyun S. Gedam",
    maintainer_email="pradyunsg@gmail.com",

    packages=["json_minify"],

    license="MIT",
    classifiers=[
        "Programming Language :: Python :: 2",
        "Programming Language :: Python :: 3",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Topic :: Utilities",
    ],
)
