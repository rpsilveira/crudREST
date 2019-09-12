unit U_Utilitarios;

interface

uses
  System.SysUtils, Data.DB, REST.Response.Adapter, System.JSON;

procedure JsonToDataset(aDataset: TDataSet; aJSON: String);
function DatasetToJson(aDataset: TDataSet): String;
function GetValueBefore(aStr, aSearch: String): String;
function GetValueAfter(aStr, aSearch: String): String;
function GetJsonValue(aJsonObj: TJSONObject; aKey: String): String;
function FloatToSQL(pValue: Double): String;

implementation

procedure JsonToDataset(aDataset: TDataSet; aJSON: String);
var
  JObj: TJSONArray;
  vConv : TCustomJSONDataSetAdapter;
begin
  if (aJSON = EmptyStr) then
    Exit;

  JObj := TJSONObject.ParseJSONValue(aJSON) as TJSONArray;
  vConv := TCustomJSONDataSetAdapter.Create(nil);

  try
    vConv.Dataset := aDataset;
    vConv.UpdateDataSet(JObj);
  finally
    vConv.Free;
    JObj.Free;
  end;
end;

function DatasetToJson(aDataset: TDataSet): String;
var
  JObj: TJsonObject;
  JArray: TJSONArray;
  i: Integer;
begin
  Result := '{}';

  if not aDataset.Active or aDataset.IsEmpty then
    Exit;

  JArray := TJSONArray.Create;
  try
    aDataset.DisableControls;

    aDataset.First;
    while not aDataset.Eof do
    begin
      JObj := TJSONObject.Create;

      for i := 0 to aDataset.FieldCount -1 do
      begin
        case aDataset.Fields[i].DataType of
          ftBoolean:
            JObj.AddPair(aDataset.Fields[i].FieldName,
                         TJSONBool.Create(aDataset.Fields[i].AsBoolean));

          ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftExtended, ftSingle, ftAutoInc,
          ftLargeint, ftSmallint, ftInteger, ftWord, ftLongWord, ftShortint:
            JObj.AddPair(aDataset.Fields[i].FieldName,
                         TJSONNumber.Create(aDataset.Fields[i].Value));
        else
          JObj.AddPair(aDataset.Fields[i].FieldName,
                       TJSONString.Create(aDataset.Fields[i].AsString));
        end;
      end;

      JArray.AddElement(JObj);

      aDataset.Next;
    end;

    Result := JArray.ToString;
  finally
    aDataset.EnableControls;
    JArray.Free;
  end;
end;

function GetValueBefore(aStr, aSearch: String): String;
begin
  Result := Copy(aStr, 1, Pos(aSearch, aStr) -1);
end;

function GetValueAfter(aStr, aSearch: String): String;
begin
  Result := Copy(aStr, Pos(aSearch, aStr) +1, Length(aStr))
end;

function GetJsonValue(aJsonObj: TJSONObject; aKey: String): String;
var
  jsValue: TJSONValue;
begin
  Result := '';

  jsValue := aJsonObj.GetValue(aKey);

  if Assigned(jsValue) then
    Result := jsValue.Value;
end;

function FloatToSQL(pValue: Double): String;
begin
  Result := StringReplace(FloatToStr(pValue), FormatSettings.DecimalSeparator, '.', []);
end;

end.
