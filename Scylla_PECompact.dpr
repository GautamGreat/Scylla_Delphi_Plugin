library Scylla_PECompact;

uses
  Windows,
  ScyllaPlugin in 'ScyllaPlugin.pas';

const
  PLUGIN_NAME = 'PECompact v2.x Delphi';
  
var
  hMapFile : THandle;
  lpViewOfFile : Pointer;

procedure FixImports;
var
  scyllaExchange : PSCYLLA_EXCHANGE;
  unresolvedImport : PUNRESOLVED_IMPORT;
  invalid_api_address : DWORD;
  correct_api_address : ^DWORD;
  check_byte : ^Byte;
begin

  scyllaExchange := PSCYLLA_EXCHANGE(lpViewOfFile);
  unresolvedImport := PUNRESOLVED_IMPORT(Pointer(scyllaExchange.offsetUnresolvedImportsArray + DWORD(lpViewOfFile)));

  scyllaExchange.status := SCYLLA_STATUS_SUCCESS;
  
  while unresolvedImport.ImportTableAddressPointer <> 0 do
  begin

    invalid_api_address := unresolvedImport.InvalidApiAddress;
    check_byte := Pointer(invalid_api_address);

    if check_byte^ = $B8 then
    begin

      Inc(invalid_api_address);
      correct_api_address := Pointer(invalid_api_address);
      unresolvedImport.InvalidApiAddress := correct_api_address^;

    end
    else
    begin
    
      scyllaExchange.status := SCYLLA_STATUS_UNSUPPORTED_PROTECTION;
      Break;

    end;

    Inc(unresolvedImport);

  end;

end;

procedure DLLMain(Reason : Integer);
begin

  case Reason of

    DLL_PROCESS_ATTACH:
    begin

      hMapFile := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, FILE_MAPPING_NAME);
      if hMapFile <> 0 then
      begin
        lpViewOfFile := MapViewOfFile(hMapFile, FILE_MAP_ALL_ACCESS, 0, 0, 0);
        if lpViewOfFile <> nil then
        begin
          FixImports;
        end
        else
          MessageBox(0, 'MapViewOfFile - Failed', 'Error', MB_ICONERROR);
      end
      else
        MessageBox(0, 'OpenFileMapping - Failed', 'Error', MB_ICONERROR);
      
    end;

    DLL_PROCESS_DETACH:
    begin

      if lpViewOfFile <> nil then
        UnmapViewOfFile(lpViewOfFile);
      if hMapFile <> 0 then
        CloseHandle(hMapFile);

    end;

  end;

end;

function ScyllaPluginNameA : PChar;
begin
  Result := PChar(PLUGIN_NAME);
end;

exports
  ScyllaPluginNameA;

begin

  DllProc := DLLMain;
  DLLMain(DLL_PROCESS_ATTACH);

end.
