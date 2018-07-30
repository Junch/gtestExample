@mkdir _build >nul
pushd _build >nul
cmake ..
cmake --build .
popd >nul
