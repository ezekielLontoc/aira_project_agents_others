$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

powershell -ExecutionPolicy Bypass -File ".\scripts\stop-runtime-stack.ps1"
powershell -ExecutionPolicy Bypass -File ".\scripts\start-runtime-stack.ps1"