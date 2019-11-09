unit ScyllaPlugin;

interface

uses
  Windows;

const
  FILE_MAPPING_NAME = 'ScyllaPluginExchange';
  
const
  SCYLLA_STATUS_SUCCESS = 0;
  SCYLLA_STATUS_UNKNOWN_ERROR = 1;
  SCYLLA_STATUS_UNSUPPORTED_PROTECTION = 2;
  SCYLLA_STATUS_IMPORT_RESOLVING_FAILED = 3;
  SCYLLA_STATUS_MAPPING_FAILED = $FF;

type
  _UNRESOLVED_IMPORT = packed record
    ImportTableAddressPointer : DWORD;
    InvalidApiAddress         : DWORD;
  end;
  PUNRESOLVED_IMPORT = ^_UNRESOLVED_IMPORT;

  _SCYLLA_EXCHANGE = packed record
    status : DWORD;
    imageBase : DWORD;
    imageSize : DWORD;
    numberOfUnresolvedImports : DWORD;
    offsetUnresolvedImportsArray : DWORD;
  end;
  PSCYLLA_EXCHANGE = ^_SCYLLA_EXCHANGE;

implementation

end.
