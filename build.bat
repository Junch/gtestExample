@mkdir _build >nul
pushd _build >nul
cmake ..
:: To change the build type, on Windows, it must be done at build time. By default it's Debug.
:: https://stackoverflow.com/questions/19024259/how-to-change-the-build-type-to-release-mode-in-cmake
cmake --build . --config Release
popd >nul
