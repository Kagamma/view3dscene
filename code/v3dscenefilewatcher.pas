{
  Copyright 2016 Trung Le (kagamma).

  This file is part of "view3dscene".

  "view3dscene" is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  "view3dscene" is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with "view3dscene"; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  ----------------------------------------------------------------------------
}

{ Utilites for watching file changes. }
unit V3DSceneFileWatcher;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

var
  EnableFileWatcher: boolean = false;
  OnReopen: procedure;  { Simple hack for scene reloading. }

{ Setup necessary parameters for file watcher. AURL contains file url that lead
  to the scene on disk. }
procedure SetupFileWatcher(const AURL: string);

{ Watch over file for any changes, it will perform check 1 time/100 frames.
  The scene will be reloaded if it's last modified is changed compare to the
  last time it was checked. }
procedure WatchingFile;

implementation

uses
  CastleURIUtils;

var
  Ticks: integer;
  FileName: string;
  LastModifiedDT: TDateTime;

procedure SetupFileWatcher(const AURL: string);
begin
  FileName := URIToFilenameSafe(AURL);
  if FileExists(FileName) then
  begin
    FileAge(FileName, LastModifiedDT);
    Ticks := 0;
  end;
end;

procedure WatchingFile;
var
  DT: TDateTime;
begin
  if EnableFileWatcher and FileExists(FileName) then
  begin
    if Ticks > 100 then
    begin
      { }
      FileAge(FileName, DT);
      if DT <> LastModifiedDT then
      begin
        OnReopen;
        LastModifiedDT := DT;
      end;
      { }
      Ticks := 0;
    end;
    Inc(Ticks);
  end;
end;

end.

