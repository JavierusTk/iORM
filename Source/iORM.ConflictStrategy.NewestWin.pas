{
  ****************************************************************************
  *                                                                          *
  *           iORM - (interfaced ORM)                                        *
  *                                                                          *
  *           Copyright (C) 2015-2023 Maurizio Del Magno                     *
  *                                                                          *
  *           mauriziodm@levantesw.it                                        *
  *           mauriziodelmagno@gmail.com                                     *
  *           https://github.com/mauriziodm/iORM.git                         *
  *                                                                          *
  ****************************************************************************
  *                                                                          *
  * This file is part of iORM (Interfaced Object Relational Mapper).         *
  *                                                                          *
  * Licensed under the GNU Lesser General Public License, Version 3;         *
  *  you may not use this file except in compliance with the License.        *
  *                                                                          *
  * iORM is free software: you can redistribute it and/or modify             *
  * it under the terms of the GNU Lesser General Public License as published *
  * by the Free Software Foundation, either version 3 of the License, or     *
  * (at your option) any later version.                                      *
  *                                                                          *
  * iORM is distributed in the hope that it will be useful,                  *
  * but WITHOUT ANY WARRANTY; without even the implied warranty of           *
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *
  * GNU Lesser General Public License for more details.                      *
  *                                                                          *
  * You should have received a copy of the GNU Lesser General Public License *
  * along with iORM.  If not, see <http://www.gnu.org/licenses/>.            *
  *                                                                          *
  ****************************************************************************
}
unit iORM.ConflictStrategy.NewestWin;

interface

uses
  iORM.ConflictStrategy.Interfaces, iORM.Context.Interfaces;

type

  TioNewestWinConflictStrategy = class(TioCustomConflictStrategy)
  public
    // Check/detect (or prepare the "query") if there is a conflict persisting the DataObject contained into the context
    class procedure CheckDeleteConflict(const AContext: IioContext); override;
    class procedure CheckUpdateConflict(const AContext: IioContext); override;
    // If a conflict is detected then this method is called from the persistence strategy to try to resolve the conflict
    // Note: the conflict strategy MUST RESOLVE the conflict or raise an exception
    class procedure ResolveDeleteConflict(const AContext: IioContext); override;
    class procedure ResolveUpdateConflict(const AContext: IioContext); override;
  end;

implementation

{ TioNewestWinConflictStrategy }

class procedure TioNewestWinConflictStrategy.CheckDeleteConflict(const AContext: IioContext);
begin
  inherited;
  // To be implemented
end;

class procedure TioNewestWinConflictStrategy.CheckUpdateConflict(const AContext: IioContext);
begin
  inherited;
  // To be implemented
end;

class procedure TioNewestWinConflictStrategy.ResolveDeleteConflict(const AContext: IioContext);
begin
  inherited;
  // To be implemented
end;

class procedure TioNewestWinConflictStrategy.ResolveUpdateConflict(const AContext: IioContext);
begin
  inherited;
  // To be implemented
end;

end.
