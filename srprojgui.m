function varargout = srprojgui(varargin)
% SRPROJGUI MATLAB code for srprojgui.fig
%      SRPROJGUI, by itself, creates a new SRPROJGUI or raises the existing
%      singleton*.
%
%      H = SRPROJGUI returns the handle to a new SRPROJGUI or the handle to
%      the existing singleton*.
%
%      SRPROJGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SRPROJGUI.M with the given input arguments.
%
%      SRPROJGUI('Property','Value',...) creates a new SRPROJGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before srprojgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to srprojgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help srprojgui
% Last Modified by GUIDE v2.5 05-Apr-2018 17:26:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @srprojgui_OpeningFcn, ...
                   'gui_OutputFcn',  @srprojgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end
% End initialization code - DO NOT EDIT


% --- Executes just before srprojgui is made visible.
function srprojgui_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to srprojgui (see VARARGIN)

% Choose default command line output for srprojgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes srprojgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end
% --- Outputs from this function are returned to the command line.
function varargout = srprojgui_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
end

function edit2_Callback(hObject, ~, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
%opens the desired file and loads data
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%select file
fil = uigetfile;            % open dialog box to choose file
data = load(fil);           % load file into struct
handles.data=data;

%change from struct to 3D matrix
names=fieldnames(data); %extract names of each frame
len=length(names); %find # of frames
handles.len=len;
[r, c]=size(eval(['data.' names{1}])); %find size of each matrix
handles.c=c;
mat=zeros(r,c,len); %preallocate
for i=1:len
    mat(:,:,i)=eval(['data.' names{i}]); %enter frame information
end

%some important preallocation
handles.f=1;
handles.fiber=[]; %preallocates handles.fiber.x for later
handles.fiber.x=[];

%convert from RF to amplitude
htf=zeros(r,c,len); %preallocate
for i=1:len
    htf(:,:,i)=hilbert(mat(:,:,i)); %find hilbert transform of each frame
end
hamp=abs(htf); %hamp is the analytic envelope
ctr=5; %compression parameter
handles.amp=20*log10(hamp/ctr); %amplitude in dB
guidata(hObject,handles);
image(handles.amp(:,:,1))
colormap(gray)
xlabel('Line number')
ylabel('Time Sample')
set(gca,'FontSize',16)
axes(handles.axes2)
hold on
end

%slider1 lets user select frame
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Max',handles.len-1);
end

% --- Executes on slider movement.
function slider1_Callback(hObject, ~, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.f=round(get(hObject,'Value'))+1;
image(handles.amp(:,:,handles.f));
guidata(hObject,handles);
end

% --- Executes on button press in play.
function play_Callback(hObject, ~, handles)
%plays the frames from current frame
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i=handles.f:handles.len
    image(handles.amp(:,:,i))
    pause(0.05)
    set(slider1,hObject,'Value')=i;
end
end

% --- Executes on button press in fascia.
function fascia_Callback(hObject, ~, handles)
% select the fascia
% hObject    handle to fascia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x_getfascia, y_getfascia]=ginput(2); %save x and y values of fascia selected

%extend graph of fascia
P=polyfit(x_getfascia,y_getfascia,1);
x_fascia=1:handles.c;
y_fascia=P(1)*x_fascia+P(2);

%save fascia and line locations
handles.fascia=[];
handles.fascia.x=x_fascia; 
handles.fascia.y=y_fascia;
guidata(hObject,handles);

%plot fascia line in red
plot(x_fascia,y_fascia,'r','LineWidth',2)
end

% --- Executes on button press in fiber.
function fiber_Callback(hObject, ~, handles)
% select fiber
% hObject    handle to fiber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x_getfib, y_getfib]=ginput(2); %save x and y values of fiber coordinates selected

%extend line to graph fiber
P2=polyfit(x_getfib,y_getfib,1);
x_fiber=1:handles.c;
y_fiber=P2(1)*x_fiber+P2(2); 

%save the fiber data
flen=length(handles.fiber.x);
handles.fiber.x{flen+1} = x_fiber;
handles.fiber.y{flen+1} = y_fiber;

%plot
plot(x_fiber,y_fiber,'b', 'LineWidth',2)
end

% --- Executes on button press in reset_fasfib.
function reset_fasfib_Callback(hObject, eventdata, handles)
% hObject    handle to reset_fasfib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fascia=[];
handles.fiber=[];
guidata(hObject,handles);
end

% --- Executes on button press in select_area.
function select_area_Callback(hObject, eventdata, handles)
%selects the area for tracking 
%hObject    handle to select_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initwin=getrect(handles.axes2); %user selects window they want
rectangle('Position',initwin,'EdgeColor','g','LineWidth',2); %plot the selected rectangle
initwin=round(initwin);%round to nearest whole numbers
st.w=initwin(3); %width of selected region
st.h=initwin(4); %height of selected region
st.x1=initwin(1); % left side of selected region
st.y1=initwin(2); % uppermost side of selected region
st.x2=st.x1+st.w-1; % fartherst right side of selected region
st.y2 = st.y1+st.h-1; %bottom side of selected region
handles.st = st;
guidata(hObject,handles);
end

% --- Executes on button press in track.
function track_Callback(hObject, eventdata, handles)
% hObject    handle to track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%define kernel
kn.h=handles.st.h; %ROI height
kn.w=handles.st.w; %ROI width
kn.sx=10; %set the size of windows of kernels
kn.sy=20; %set the size of windows of kernels
kn.rx=kn.h; %change to adjust computing speed
kn.cy=kn.w; %change to adjust computing speed

% default minimum elements in the lateral/axial direction
hx = 7; 
hy = 1;
%potentially change hx, hy
if kn.h/kn.rx/2 > hx
    hx = floor(kn.h/rx/2);
end  
if kn.w/kn.cy/2 > hy
    hy = floor(kn.w/cy/2);
end    
%set finalized hx and hy
kn.hx = hx;
kn.hy = hy;

num=1; %preallocate

%perform tracking on frames
for i=handles.f:handles.len-1
    data{num}=NCorrEst(handles.amp(:,:,i),handles.amp(:,:,i+1),handles.st,kn);
    num=num+1;
end
end

% --- Executes on button press in track_review.
function track_review_Callback(hObject, eventdata, handles)
% hObject    handle to track_review (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in diameter.
function diameter_Callback(hObject, eventdata, handles)
% hObject    handle to diameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of diameter
end

% --- Executes on button press in penangle.
function penangle_Callback(hObject, eventdata, handles)
% hObject    handle to penangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of penangle
end

% --- Executes on button press in movement.
function movement_Callback(hObject, eventdata, handles)
% hObject    handle to movement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of movement
end

% --- Executes on button press in length.
function length_Callback(hObject, eventdata, handles)
% hObject    handle to length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of length
end
