function ff = fixfocus(msg)
%FIXFOCUS Fix focus errors when opening a selection dialog from a callback.
%   FIXFOCUS provides a workaround to an annoying, decades-old MATLAB error
%   that opens a selection dialog box (such as a file selection dialog box)
%   *behind* the calling app or 'uifigure' window and does *not* return the
%   focus to it once the user closes the dialog box.
%
%   To apply the fix, in your callback function call FIXFOCUS before
%   opening the selection dialog box and delete it right after:
%
%       ff = fixfocus;
%       [file,location] = uigetfile;
%       delete(ff);
%
%   FIXFOCUS can also be called with a text argument, in which case the
%   text is displayed in the title bar during the short time the FIXFOCUS
%   figure is visible.
%
%   FIXFOCUS works with the following selection dialog boxes:
%       uigetfile
%       uiputfile
%       uigetdir
%       uiopen
%       uisave
%
%See also uigetfile, uigetdir, uiputfile, uiopen, uisave

% Created 2024-05-13 by Jorg C. Woehl
% Inspired by https://www.mathworks.com/matlabcentral/answers/296305-appdesigner-window-ends-up-in-background-after-uigetfile#answer_427026

% Find the handle of the 'uifigure' whose callback is currently executing
appWindow = gcbf;
if isempty(appWindow)
    error('uifix:UIFigureNotFound', 'Calling app/uifigure not found.');
end

% Default text to appear in superimposed title bar is that of the calling
% app or 'uifigure' window
if (nargin < 1)
    msg = appWindow.Name;
end

% Create dummy figure (requires 'figure', not 'uifigure')
ff = figure('Position',appWindow.Position, 'MenuBar','none',...
    'Name',msg, 'Resize','off',...
    'NumberTitle','off', 'Visible','off',...
    'CloseRequestFcn','', 'DeleteFcn', @(src,event) figure(appWindow));

% Superimpose it on the title bar of the calling app or 'uifigure' window
ff.Position(2) = ff.Position(2)+ff.Position(4);
ff.Position(4) = 0;

% Move it into focus, then make it invisible
ff.Visible = 'on';
drawnow;
ff.Visible = 'off';

end