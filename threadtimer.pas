
unit threadtimer;


interface

uses
  Windows, SysUtils, Classes;

type

  TThreadPriority = Classes.TThreadPriority;

  ira_ThreadTimer = class(TComponent)
  private
    FEnabled: Boolean;
    FInterval: Cardinal;
    FKeepAlive: Boolean;
    FOnTimer: TNotifyEvent;
    FPriority: TThreadPriority;
    FStreamedEnabled: Boolean;
    FThread: TThread;
    procedure SetEnabled(const Value: Boolean);
    procedure SetInterval(const Value: Cardinal);
    procedure SetOnTimer(const Value: TNotifyEvent);
    procedure SetPriority(const Value: TThreadPriority);
    procedure SetKeepAlive(const Value: Boolean);
  protected
    procedure DoOnTimer;
    procedure Loaded; override;
    procedure StopTimer;
    procedure UpdateTimer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Thread: TThread read FThread;
  published

    property Enabled: Boolean read FEnabled write SetEnabled default False;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property KeepAlive: Boolean read FKeepAlive write SetKeepAlive default False;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
    property Priority: TThreadPriority read FPriority write SetPriority default tpNormal;
  end;


implementation

uses
  Messages;

type
  ira_TimerThread = class(TThread)
  private
    FEvent: THandle;
    FHasBeenSuspended: Boolean;
    FInterval: Cardinal;
    FTimer: ira_ThreadTimer;

    FPriority: TThreadPriority;

    FSynchronizing: Boolean;
  protected
    procedure DoSuspend;
    procedure Execute; override;
  public
    constructor Create(ATimer: ira_ThreadTimer);
    destructor Destroy; override;
    procedure Stop;
    property Interval: Cardinal read FInterval;
    property Timer: ira_ThreadTimer read FTimer;
    property Synchronizing: Boolean read FSynchronizing;
  end;

function SubtractMin0(const Big, Small: Cardinal): Cardinal;
begin
  if Big <= Small then
    Result := 0
  else
    Result := Big - Small;
end;

//=== { ira_TimerThread } =====================================================

constructor ira_TimerThread.Create(ATimer: ira_ThreadTimer);
begin
  inherited Create(False);


  FEvent := CreateEvent(nil, False, False, nil);
  if FEvent = 0 then
    RaiseLastOSError;
  FInterval := ATimer.FInterval;
  FTimer := ATimer;
  FPriority := ATimer.Priority;

end;

destructor ira_TimerThread.Destroy;
begin
  Stop;
  inherited Destroy;
  if FEvent <> 0 then
    CloseHandle(FEvent);
end;

procedure ira_TimerThread.DoSuspend;
begin
  FHasBeenSuspended := True;
  Suspended := True;
end;

procedure ira_TimerThread.Execute;
var
  Offset, TickCount: Cardinal;
begin

  Priority := FPriority;
  if WaitForSingleObject(FEvent, Interval) <> WAIT_TIMEOUT then
    Exit;

  while not Terminated do
  begin
    FHasBeenSuspended := False;

    TickCount := GetTickCount;
    if not Terminated then
    begin
      FSynchronizing := True;
      try
        Synchronize(FTimer.DoOnTimer);
      finally
        FSynchronizing := False;
      end;
    end;

    if FHasBeenSuspended then
      Offset := 0
    else
    begin
      Offset := GetTickCount;
      if Offset >= TickCount then
        Dec(Offset, TickCount)
      else
        Inc(Offset, High(Cardinal) - TickCount);
    end;

    if Terminated or (WaitForSingleObject(FEvent, SubtractMin0(Interval, Offset)) <> WAIT_TIMEOUT) then
      Exit;
  end;
end;

procedure ira_TimerThread.Stop;
begin
  Terminate;
  SetEvent(FEvent);
  if Suspended then
    Suspended := False;
end;

//=== { ira_ThreadTimer } =====================================================

constructor ira_ThreadTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInterval := 1000;
  FPriority := tpNormal;
end;

destructor ira_ThreadTimer.Destroy;
begin
  StopTimer;
  inherited Destroy;
end;

procedure ira_ThreadTimer.DoOnTimer;
begin
  if csDestroying in ComponentState then
    Exit;

  try
    if Assigned(FOnTimer) then
      FOnTimer(Self);
  except
    if Assigned(ApplicationHandleException) then
      ApplicationHandleException(Self);
  end;
end;

procedure ira_ThreadTimer.Loaded;
begin
  inherited Loaded;
  SetEnabled(FStreamedEnabled);
end;

procedure ira_ThreadTimer.SetEnabled(const Value: Boolean);
begin
  if csLoading in ComponentState then
    FStreamedEnabled := Value
  else begin
    if FEnabled <> Value then
    begin
      FEnabled := Value;
      UpdateTimer;
    end;
  end;
 end;

procedure ira_ThreadTimer.SetInterval(const Value: Cardinal);
begin
  if FInterval <> Value then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure ira_ThreadTimer.SetKeepAlive(const Value: Boolean);
begin
  if FKeepAlive <> Value then
  begin
    StopTimer;
    FKeepAlive := Value;
    UpdateTimer;
  end;
end;

procedure ira_ThreadTimer.SetOnTimer(const Value: TNotifyEvent);
begin
  if @FOnTimer <> @Value then
  begin
    FOnTimer := Value;
    UpdateTimer;
  end;
end;


procedure ira_ThreadTimer.SetPriority(const Value: TThreadPriority);
begin
  if FPriority <> Value then
  begin
    FPriority := Value;
    if FThread <> nil then
      FThread.Priority := FPriority;
  end;
end;


procedure ira_ThreadTimer.StopTimer;
begin
  if FThread <> nil then
  begin
    ira_TimerThread(FThread).Stop;
    if not ira_TimerThread(FThread).Synchronizing then
//     FreeAndNil(FThread)
      FThread.Free
    else
    begin
      ira_TimerThread(FThread).FreeOnTerminate := True;
      FThread := nil
//      FThread.Free;

    end;
  end;
end;

procedure ira_ThreadTimer.UpdateTimer;
var
  DoEnable: Boolean;
begin
  if ComponentState * [csDesigning, csLoading] <> [] then
    Exit;

  DoEnable := FEnabled and Assigned(FOnTimer) and (FInterval > 0);

  if not KeepAlive then
    StopTimer;

  if DoEnable then
  begin
    if FThread <> nil then
    begin
      ira_TimerThread(FThread).FInterval := FInterval;
      if FThread.Suspended then
        FThread.Suspended := False;
    end
    else
      FThread := ira_TimerThread.Create(Self);
  end
  else
  if FThread <> nil then
  begin
    if not FThread.Suspended then
      ira_TimerThread(FThread).DoSuspend;

    ira_TimerThread(FThread).FInterval := FInterval;
  end;
end;


end.