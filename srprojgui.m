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
%uiwait(handles.figure1);

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
handles.mat=mat;
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
    %set(slider1,hObject,'Value')=i;
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
handles.fiber.x=[];
image(handles.amp(:,:,handles.f));
guidata(hObject,handles);
end

% --- Executes on button press in select_area.
function select_area_Callback(hObject, eventdata, handles)
%selects the area for tracking 
%hObject    handle to select_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initstate=getrect(handles.axes2); %user selects window they want
rectangle('Position',initstate,'EdgeColor','g','LineWidth',2); %plot the selected rectangle
handles.initstate = round(initstate);
guidata(hObject,handles);
%image(handles.amp(st.y1:st.y2,st.x1:st.x2,handles.f),'Parent',handles.axes1)
end

% --- Executes on button press in track.
function track_Callback(hObject, eventdata, handles)
% tracks the fibers through 20 frames 
% hObject    handle to track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Create kenel and import st from select area
initstate=handles.initstate; %import initial state
x1=initstate(1);
y1=initstate(2);
w=initstate(3);
h=initstate(4);
st = state(initstate);
%search range
sX=10;
sY=20;
%how much of the ROI to search
rX=round(h/2);
cY=round(w/2);
method = [sX, sY, rX, cY];
kn = kernel(method,st);

%select frame range to track
initframe=handles.f; %initial frame for tracking
%select number of frames to track
numframes=5;

%pick the end frame
if handles.f+numframes<handles.len-1
    endframe=handles.f+numframes;
else
    endframe=handles.len-1;
end

%preallocate
matrix_meanu=0;
matrix_meanv=0;
num=1;
trackData=[];

%load amplitude data
mat=handles.mat;

%tracking cycles through frames
for i= initframe:(endframe-1)
    disp(i)
    figure;
    if i==initframe
       %generates the Target and template
        st = state(initstate);
        templ= mat(:,:,i);
        tar= mat(:,:,i+1);
        data = NCorrEst(templ,tar,st,kn);
        %initalizes the mean u and v vectors for later
        %statistical use
        Cart_meanu_vec=zeros(length(initframe:endframe)-1,1);
        Cart_meanv_vec=zeros(length(initframe:endframe)-1,1);
        %{
        h=figure;
        i1=image(amp(:,:,initframe));
        colormap(gray)
        hold on
        fs=num2str(initframe);
        title(['Frame ' fs],'FontSize',15)
        ylabel('Time Sample','FontSize',15)
        rectangle('Position',initstate,'EdgeColor','y')
        %}
        
    else
        %alters the ROI depending on how the movement from the last frame
        x1=round(x1 + Cart_meanu);
        y1=round(y1 + Cart_meanv);
        %size of region of interest remains the same
        initstate = [x1, y1, w, h];
        st = state(initstate);
        %method stays same
        kn = kernel(method,st);
        %generates the Target and template
        templ= mat(:,:,i);
        tar= mat(:,:,i+1);
        data = NCorrEst(templ,tar,st,kn);
        %rectangle('Position',initstate,'EdgeColor','y')
    end
    % Create the quiver
    qdata=quiver(data.v, data.u);
    %disp(["sX " sX "sY " sY] )
    title(['quiver of Temp: ' num2str(i) ' to Tar: ' num2str(i+1)])
    %Generates the mean u and v vectors
    fakeu=zeros(size(data.v));
    fakev=fakeu;
    midx=round(rX/2);
    midy=round(cY/2);
    
    nonz_u= data.u((data.u ~= 0));
    matrix_meanu=mean(nonz_u);
    disp(["meanu:" matrix_meanu])
    
    nonz_v= data.v((data.v ~= 0));
    matrix_meanv=mean(nonz_v);
    disp(["meanv:" matrix_meanv])
    
    %Middle of figure is first mean vec and
    %decending from there is +1
    fakeu(midx+i,midy)=matrix_meanu;
    fakev(midx+i,midy)=matrix_meanv;
    Cart_meanu=matrix_meanv;
    Cart_meanv=matrix_meanu;
    
    Cart_meanu_vec(i)=Cart_meanu;
    Cart_meanv_vec(i)=Cart_meanv;
    %plotting the mean vector of the entire ROI
    hold on
    qdata2=quiver(fakev,fakeu);
    qdata2.LineWidth=3;
    qdata2.AutoScaleFactor=9;
    qdata2.MaxHeadSize=7;
    set(handles.axes1,'Ydir','reverse') %need to reverse the graph
    hold off
    %save the tracking data
    trackData{num}=data;
    num=num+1;
end
handles.trackData=trackData;
guidata(hObject,handles);
end

% --- Executes on button press in track_review.
function track_review_Callback(hObject, eventdata, handles)
% hObject    handle to track_review (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
track=handles.track;

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

% --- Outputs from this function are returned to the command line.
function varargout = srprojgui_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1}= handles;
end


function st = state(initstate)
    % Unfortunately, MATLAB use column-first method to arrange 2D Matrix, or
    % a 2D image. So we need to use a function to make things compatible.
    
    % check if numbers need to be integer
    if any(initstate - round(initstate))
        disp('warning: initstate is not an integer vector');
    end

    
    initstate = round(initstate);
    y = initstate(1);% x axis at the Top left corner
    x = initstate(2);
    st.w = initstate(3);% width of the rectangle
    st.h = initstate(4);% height of the rectangle

    st.x1 = x;
    st.x2 = x+st.h-1;
    st.y1 = y;
    st.y2 = y+st.w-1;
end

function kn = kernel(set,state)
    % search radius in X/Y direction
    sx = set(1);
    sy = set(2);
    rx = set(3);
    cy = set(4);
    
    kn.sx = sx;
    kn.sy = sy;
    % # locs (rows,cols) that need to be tracked
    kn.rx = rx;
    kn.cy = cy;
    
    % region of interest width and height
    kn.w = state.w;
    kn.h = state.h;
    
    % default minimum elements in the lateral/axial direction
    hx = 7; 
    hy = 1;
    
    if kn.h/rx/2 > hx
        hx = floor(kn.h/rx/2);
    end
    
    if kn.w/cy/2 > hy
        hy = floor(kn.w/cy/2);
    end
        
    kn.hx = hx;
    kn.hy = hy;

end
