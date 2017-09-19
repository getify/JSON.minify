from setuptools import setup

with open("README.md") as f:
    long_description = f.read()

setup(
    # Metadata
    name="JSON_minify",
    version="0.2.0",
    packages=find_packages(),
    include_package_data=True,
    license='MIT License',
    description=(
        "A simple script to minify valid JSON, containing JavaScript comments"
    ),
    long_description=long_description,
    url="https://github.com/fiduswriter/JSON.minify/tree/python",
    author="Gerald Storer",

    maintainer="Johannes Wilm",
    maintainer_email="johannes@fiduswriter.org",

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