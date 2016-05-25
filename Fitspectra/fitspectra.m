function fitspectra(Action);
 
  
% Written by Brian J. Zadler
%  John Scales (original author of fitspectra)
% Physical Aoustics Lab, Colorado School of Mines, Golden, CO
% 
%
%%%%
% GUI integrating resonance spectrum fitting code 
%  written by the author.  Originally written in Scilab.
%
%%%%
% MOSTLY finished Feb. 18, 2005.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  persistent fitspectraFig;
  
  if isempty(findobj('tag','fitspectraFig'))
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  start cut here
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Later, copy all this to another file like fispectraGUI.m
    % fitspectraGUI
    
    %%%%%%%%%%%%%%%
    % Create figure
    %%%%%%%%%%%%%%%  
    fitspectraFig = figure('Position', [60 300 800 600], ...
			   'Toolbar','Figure', ...
			   'Tag','fitspectraFig', ...
			   'Resize', 'off');
    
    %%%%%%%%%%%%%
    % Create axes
    %%%%%%%%%%%%%
    axes1 = axes('Parent',fitspectraFig, ...
		 'Tag', 'axes1', ...  
		 'Position', [0.1 0.42 0.7 0.5], ...
		 'UserData', [0 1]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Some default values...
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figpos=get(gcf,'Position');
    bXSize = 100;
    bYSize = 20;
    miniXsize = 20;
    miniYsize = 20;
    
    pos = get(axes1,'Position');
        
    xpos1 = figpos(3)*( (pos(1)+pos(3)) + ...
			(1-(pos(1)+pos(3)))/2 )-bXSize/2;
    ypos1 = figpos(4)*( (pos(2)+pos(4)) ) - bYSize;
  
      
    labelGui;
    menuGui;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % begin file and listbox uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%
    % filelistbox uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style', 'text', ...
	      'Position', [25 65 bXSize bYSize], ...
	      'String', 'Columns');
    uicontrol('Style', 'text', ...
	      'Position', [125 65 bXSize bYSize], ...
	      'Tooltipstring','# of Columbs in the data set', ...
	      'String', '', ...
	      'Value', 2, ...
	      'Tag', 'numCol');
    uicontrol('Style', 'text', ...
	      'Position', [25 45 bXSize bYSize], ...
	      'String', 'File Type');
    uicontrol('Style', 'popup', ...
	      'Position', [125 45 bXSize bYSize], ...
	      'String', '*.dat|*.0Hz|*.asc|*.DAT|*.ASC', ...
	      'Tooltipstring', ...
	      'File extension: edit fitspectra.m line 137 for more types', ...
	      'Tag', 'extType', ...
	      'CallBack','fitspectra(''changeFileType'')');
    uicontrol('Style','listbox', ...
	      'Position',[25 85 200 100], ...
	      'String','the files', ...
	      'BackgroundColor',[1 1 1], ...
	      'Tag','filelistbox', ...
	      'Value',1, ...
	      'Callback','fitspectra(''selectFile'')');
    
    fileListStruct=dir('*.dat');
    fileList={fileListStruct.name};
    fileListHndl=findobj(gcf,'Tag','filelistbox');
    set(fileListHndl,'String',fileList);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % end file and listbox uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % begin code-specific uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % B0 adjustment uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    B0xpos=340;
    B0ypos=180;
    uicontrol('Style','text', ...
	      'Position',[B0xpos B0ypos 0.75*bXSize bYSize], ...
	      'String','B0', ...
	      'Tag', 'B0text', ...
	      'FontWeight', 'bold', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 14);
    uicontrol('Style','text', ...
	      'Position',[B0xpos-0.25*bXSize B0ypos-bYSize 1.25*bXSize bYSize], ...
	      'Tag', 'B0Size', ...
	      'String','0', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 12);
    uicontrol('Style','edit', ...
	      'Tag','minB0', ...
	      'Position',[B0xpos-bXSize B0ypos-2*bYSize bXSize bYSize], ...
	      'String', '0', ...
	      'Callback', 'fitspectra(''B0SliderRange'')');
    uicontrol('Style','edit', ...
	      'Tag','maxB0', ...
	      'Position',[B0xpos+0.75*bXSize B0ypos-2*bYSize bXSize bYSize], ...
	      'String', '10', ...
	      'Callback', 'fitspectra(''B0SliderRange'')');
    
    B0SliderVal = (eval(get(findobj('Tag','minB0'),'String'))+ ...
		     eval(get(findobj('Tag','maxB0'),'String')))/2;
    uicontrol('Style','slider', ...
	      'Tag', 'B0Slider', ...
	      'Tooltipstring','', ...
	      'Value', B0SliderVal, ...
	      'Min', eval(get(findobj('Tag','minB0'),'String')), ...
	      'Max', eval(get(findobj('Tag','maxB0'),'String')), ...
	      'Position',[B0xpos B0ypos-2*bYSize 0.75*bXSize bYSize], ...
	      'Callback', 'fitspectra(''B0SliderMove'')');
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % B1 adjustment uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    B1xpos=B0xpos;
    B1ypos=B0ypos-(3*bYSize+3);
    uicontrol('Style','text', ...
	      'Position',[B1xpos B1ypos 0.75*bXSize bYSize], ...
	      'String','B1', ...
	      'FontWeight', 'bold', ...
	      'Tag', 'B1text', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 14);
    uicontrol('Style','text', ...
	      'Position',[B1xpos-0.25*bXSize B1ypos-bYSize 1.25*bXSize bYSize], ...
	      'Tag', 'B1Size', ...
	      'String','0', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 12);
    uicontrol('Style','edit', ...
	      'Tag','minB1', ...
	      'Position',[B1xpos-bXSize B1ypos-2*bYSize bXSize bYSize], ...
	      'String', '0', ...
	      'Callback', 'fitspectra(''B1SliderRange'')');
    uicontrol('Style','edit', ...
	      'Tag','maxB1', ...
	      'Position',[B1xpos+0.75*bXSize B1ypos-2*bYSize bXSize bYSize], ...
	      'String', '10', ...
	      'Callback', 'fitspectra(''B1SliderRange'')');
    
    B1SliderVal = (eval(get(findobj('Tag','minB1'),'String'))+ ...
		     eval(get(findobj('Tag','maxB1'),'String')))/2;
    uicontrol('Style','slider', ...
	      'Tag', 'B1Slider', ...
	      'Value', B1SliderVal, ...
	      'Min', eval(get(findobj('Tag','minB1'),'String')), ...
	      'Max', eval(get(findobj('Tag','maxB1'),'String')), ...
	      'Position',[B1xpos B1ypos-2*bYSize 0.75*bXSize bYSize], ...
	      'Callback', 'fitspectra(''B1SliderMove'')');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % C adjustment uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    Cxpos=B0xpos;
    Cypos=B0ypos-(6*bYSize+3);
    uicontrol('Style','text', ...
	      'Position',[Cxpos Cypos 0.75*bXSize bYSize], ...
	      'String','C', ...
	      'FontWeight', 'bold', ...
	      'Tag', 'Ctext', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 14);
    uicontrol('Style','text', ...
	      'Position',[Cxpos-0.25*bXSize Cypos-bYSize 1.25*bXSize bYSize], ...
	      'Tag', 'CSize', ...
	      'String','0', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 12);
    uicontrol('Style','edit', ...
	      'Tag','minC', ...
	      'Position',[Cxpos-bXSize Cypos-2*bYSize bXSize bYSize], ...
	      'String', '0', ...
	      'Callback', 'fitspectra(''CSliderRange'')');
    uicontrol('Style','edit', ...
	      'Tag','maxC', ...
	      'Position',[Cxpos+0.75*bXSize Cypos-2*bYSize bXSize bYSize], ...
	      'String', '10', ...
	      'Callback', 'fitspectra(''CSliderRange'')');
    
    CSliderVal = (eval(get(findobj('Tag','minC'),'String'))+ ...
		     eval(get(findobj('Tag','maxC'),'String')))/2;
    uicontrol('Style','slider', ...
	      'Tag', 'CSlider', ...
	      'Value', CSliderVal, ...
	      'Min', eval(get(findobj('Tag','minC'),'String')), ...
	      'Max', eval(get(findobj('Tag','maxC'),'String')), ...
	      'Position',[Cxpos Cypos-2*bYSize 0.75*bXSize bYSize], ...
	      'Callback', 'fitspectra(''CSliderMove'')');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % D adjustment uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    Dxpos=340+0.75*bXSize+2*bXSize+10;
    Dypos=180;
    uicontrol('Style','text', ...
	      'Position',[Dxpos Dypos 0.75*bXSize bYSize], ...
	      'String','D', ...
	      'FontWeight', 'bold', ...
	      'Tag', 'Dtext', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 14);
    uicontrol('Style','text', ...
	      'Position',[Dxpos-0.25*bXSize Dypos-bYSize 1.25*bXSize bYSize], ...
	      'Tag', 'DSize', ...
	      'String','0', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 12);
    uicontrol('Style','edit', ...
	      'Tag','minD', ...
	      'Position',[Dxpos-bXSize Dypos-2*bYSize bXSize bYSize], ...
	      'String', '0', ...
	      'Callback', 'fitspectra(''DSliderRange'')');
    uicontrol('Style','edit', ...
	      'Tag','maxD', ...
	      'Position',[Dxpos+0.75*bXSize Dypos-2*bYSize bXSize bYSize], ...
	      'String', '10', ...
	      'Callback', 'fitspectra(''DSliderRange'')');
    
    DSliderVal = (eval(get(findobj('Tag','minD'),'String'))+ ...
		     eval(get(findobj('Tag','maxD'),'String')))/2;
    uicontrol('Style','slider', ...
	      'Tag', 'DSlider', ...
	      'Value', DSliderVal, ...
	      'Min', eval(get(findobj('Tag','minD'),'String')), ...
	      'Max', eval(get(findobj('Tag','maxD'),'String')), ...
	      'Position',[Dxpos Dypos-2*bYSize 0.75*bXSize bYSize], ...
	      'Callback', 'fitspectra(''DSliderMove'')');
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Gam adjustment uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    Gamxpos=Dxpos;
    Gamypos=Dypos-(3*bYSize+3);
    uicontrol('Style','text', ...
	      'Position',[Gamxpos Gamypos 0.75*bXSize bYSize], ...
	      'String','Gam', ...
	      'FontWeight', 'bold', ...
	      'Tag', 'Gamtext', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 14);
    uicontrol('Style','text', ...
	      'Position',[Gamxpos-0.25*bXSize Gamypos-bYSize 1.25*bXSize bYSize], ...
	      'Tag', 'GamSize', ...
	      'String','0', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 12);
    uicontrol('Style','edit', ...
	      'Tag','minGam', ...
	      'Position',[Gamxpos-bXSize Gamypos-2*bYSize bXSize bYSize], ...
	      'String', '0', ...
	      'Callback', 'fitspectra(''GamSliderRange'')');
    uicontrol('Style','edit', ...
	      'Tag','maxGam', ...
	      'Position',[Gamxpos+0.75*bXSize Gamypos-2*bYSize bXSize bYSize], ...
	      'String', '10', ...
	      'Callback', 'fitspectra(''GamSliderRange'')');
    
    GamSliderVal = (eval(get(findobj('Tag','minGam'),'String'))+ ...
		     eval(get(findobj('Tag','maxGam'),'String')))/2;
    uicontrol('Style','slider', ...
	      'Tag', 'GamSlider', ...
	      'Value', GamSliderVal, ...
	      'Min', eval(get(findobj('Tag','minGam'),'String')), ...
	      'Max', eval(get(findobj('Tag','maxGam'),'String')), ...
	      'Position',[Gamxpos Gamypos-2*bYSize 0.75*bXSize bYSize], ...
	      'Callback', 'fitspectra(''GamSliderMove'')');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Freq adjustment uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Freqxpos=Dxpos;
    Freqypos=Dypos-(6*bYSize+3);
    uicontrol('Style','text', ...
	      'Position',[Freqxpos Freqypos 0.75*bXSize bYSize], ...
	      'String','Freq', ...
	      'FontWeight', 'bold', ...
	      'Tag', 'Freqtext', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 14);
    uicontrol('Style','text', ...
	      'Position',[Freqxpos-0.25*bXSize Freqypos-bYSize 1.25*bXSize bYSize], ...
	      'Tag', 'FreqSize', ...
	      'String','0', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 12);
    uicontrol('Style','edit', ...
	      'Tag','minFreq', ...
	      'Position',[Freqxpos-bXSize Freqypos-2*bYSize bXSize bYSize], ...
	      'String', '0', ...
	      'Callback', 'fitspectra(''FreqSliderRange'')');
    uicontrol('Style','edit', ...
	      'Tag','maxFreq', ...
	      'Position',[Freqxpos+0.75*bXSize Freqypos-2*bYSize bXSize bYSize], ...
	      'String', '10', ...
	      'Callback', 'fitspectra(''FreqSliderRange'')');
    
    FreqSliderVal = (eval(get(findobj('Tag','minFreq'),'String'))+ ...
		     eval(get(findobj('Tag','maxFreq'),'String')))/2;
    uicontrol('Style','slider', ...
	      'Tag', 'FreqSlider', ...
	      'Value', FreqSliderVal, ...
	      'Min', eval(get(findobj('Tag','minFreq'),'String')), ...
	      'Max', eval(get(findobj('Tag','maxFreq'),'String')), ...
	      'Position',[Freqxpos Freqypos-2*bYSize 0.75*bXSize bYSize], ...
	      'Callback', 'fitspectra(''FreqSliderMove'')');
   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % peak selection uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style', 'pushbutton', ...
	      'Position', [xpos1 ypos1-7*bYSize bXSize 2*bYSize], ...
	      'String', 'Get Peaks', ...
	      'Tag', 'peakButton', ...
	      'CallBack','fitspectra(''getPeaks'')', ...
	      'Tooltipstring', ...
	      'Click inside axes to choose peaks,press Enter to terminate.', ...
	      'ForegroundColor',[.2 1 .2], ...
	      'BackgroundColor',[.6 .6 .6], ...
	      'FontSize', 16);
%    uicontrol('Style', 'text', ...
%	      'Position', [xpos1 ypos1-8*bYSize 60 20], ...
%	      'String', 'RESET', ...
%	      'ForegroundColor',[0 1 0], ...
%	      'BackgroundColor',[.6 .6 .6], ...
%	      'FontSize', 12, ...
%	      'FontWeight', 'bold');
%    uicontrol('Style', 'pushbutton', ...
%	      'Position', [xpos1+60 ypos1-8*bYSize miniXsize miniYsize], ...
%	      'String', 'X', ...
%	      'Tag', 'resetPeaksButton', ...
%	      'CallBack','fitspectra(''resetPeaks'')', ...
%	      'Tooltipstring','Reset number of peaks chosen', ...
%	      'ForegroundColor',[0 0 0], ...
%	      'BackgroundColor',[1 .1 .1], ...
%	      'FontWeight', 'bold', ...
%	      'FontSize', 12);
  
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % Fit button uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style', 'checkbox', ...
	      'Position', [xpos1 ypos1-9*bYSize bXSize bYSize], ...
	      'String', 'Iterative fit?', ...
	      'Tag', 'iterativeFitButton', ...
	      'Value',1, ...
	      'Tooltipstring', ...
	      'Perform iterative fit using last fit parameters', ...
	      'ForegroundColor',[0 0 0], ...
	      'BackgroundColor',[.4 .9 .4], ...
	      'FontWeight', 'bold', ...
	      'FontSize', 12);
    uicontrol('Style', 'pushbutton', ...
	      'Position', [xpos1 ypos1-11*bYSize bXSize 2*bYSize], ...
	      'String', 'Fit Model', ...
	      'Enable', 'off', ...
	      'Tag', 'fitButton', ...
	      'BackgroundColor',[.4 1 .4], ...
	      'Tooltipstring','Start a fit', ...
	      'Fontsize',14, ...
	      'CallBack','fitspectra(''fitButton'')');
    uicontrol('Style', 'pushbutton', ...
	      'Position', [xpos1+bXSize/2 ypos1-12*bYSize bXSize/2 bYSize], ...
	      'String', 'HALT', ...
	      'Tag', 'haltButton', ...
	      'Tooltipstring','Halt the fit process', ...
	      'ForegroundColor',[0 0 0], ...
	      'BackgroundColor',[1 0 0], ...
	      'Fontsize',12, ...
	      'CallBack','fitspectra(''haltButton'')');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Save button
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style', 'pushbutton', ...
	      'Position', [xpos1 ypos1-13*bYSize bXSize bYSize], ...
	      'String', 'SAVE', ...
	      'Tag', 'saveButton', ...
          'Enable', 'off', ...
	      'Tooltipstring','Save the parameters to file', ...
	      'ForegroundColor',[0 0 0], ...
	      'BackgroundColor',[.3 .4 .7], ...
	      'Fontsize',12, ...
	      'CallBack','fitspectra(''saveButton'')');
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Peak parameter changing uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uicontrol('Style','text', ...
	      'Position',[xpos1 ypos1-15*bYSize bXSize bYSize], ...
	      'String','Peak #', ...
	      'ForegroundColor',[0 0 1], ...
	      'FontSize', 12);
    uicontrol('Style', 'popup', ...
	      'Position', [xpos1 ypos1-16*bYSize bXSize bYSize], ...
	      'String', 'NULL', ...
	      'Tooltipstring','Select parameters of peak number...', ...
	      'Tag', 'changePeakPop', ...
	      'CallBack','fitspectra(''changePeakParams'')');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % end code-specific uicontrols
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  end cut here
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    % End of initialization %   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    
  elseif nargin == 0 & isempty(findobj('tag','fitspectraFig')) == 0
    
  elseif nargin == 1 & isempty(findobj('tag','fitspectraFig')) == 0
    % Action argument supplied (selects callback function)
    
    switch Action
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % begin file selection Actions
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     case 'selectFile' % Load *.dat file into axes
      co=['b';'g';'r';'y';'c';'k';'m'];
      h=findobj('tag','axes1');axes(h);
      
      set(findobj('Tag','peakButton'),'Enable','on');
      set(findobj('Tag','fitButton'),'Enable','off');
      set(findobj('Tag','saveButton'),'Enable','off');
      
      global spectrum;  
      fileIndex=get(gcbo,'Value');
      fileList=get(gcbo,'String');
      fileName=fileList{fileIndex};   
      
      %specify number of columns, 1 or 2
      %numCol = get(findobj('tag','numCol'),'Value');
      
      fid=fopen(fileName,'r'); 
      spectrum.filename = fileName;
      spectrum.col = size(str2num(fgetl(fid)),2);
      set(findobj('tag','numCol'),'string',num2str(spectrum.col));
      spectrum.data = fscanf(fid,'%g',[spectrum.col,inf]);
      spectrum.datalen = size(spectrum.data,2);
            
      if spectrum.col == 1
	set(findobj('tag','numCol'),'foregroundcolor',[0 0 0]);
	spectrum.one = spectrum.data(spectrum.col,1:size(spectrum.data,2))';
      elseif spectrum.col ==2
	set(findobj('tag','numCol'),'foregroundcolor',[0 0 0]);
	spectrum.one = spectrum.data(1,1:size(spectrum.data,2))'/1000;
	
	spectrum.two = spectrum.data(2,1:size(spectrum.data,2))';
	spectrum.two = spectrum.two/max(spectrum.two);
      else
	set(findobj('tag','numCol'),'foregroundcolor',[1 0 0]);
      end
      
      
      dummy = get(h,'UserData');
      nLO = dummy(1);
      currentColor = dummy(2);
      
      hold off;
      if get(findobj('Tag','holdAxes1Button'),'Value') == 1
	hold on;
	nLO=1;
	currentColor=currentColor+1;
      else
	nLO=0;
	currentColor=1;
      end
      set(h,'UserData',[nLO currentColor]);
     
      if nLO ~= 0
	if currentColor < size(co,1)
	  set(h,'UserData',[nLO currentColor]);
	else
	  set(h,'UserData',[1 1]);
	end
      else
	set(h,'UserData',[0 1]);
      end
      dummy = get(h,'UserData');
      
           
      if spectrum.col == 1
	plot(spectrum.one,strcat(co(currentColor),'-'));
      else
	plot(spectrum.one,spectrum.two,strcat(co(currentColor),'-'));
      end
	
      h=gca;set(h,'Tag','axes1');
      set(h,'UserData',dummy);
     
      set(findobj('Tag','xButt'),'String','X-label: off'); 
      set(findobj('Tag','xButt'),'Value',0);
      set(findobj('Tag','yButt'),'String','Y-label: off');
      set(findobj('Tag','yButt'),'Value',0);
      set(findobj('Tag','titleButt'),'String','Title: off');
      set(findobj('Tag','titleButt'),'Value',0);
      
     case 'changeFileType'
      dVal = get(findobj('tag','extType'),'Value');
      dStr = get(findobj('tag','extType'),'String');
      fileListStruct=dir(dStr(dVal,:));
      fileList={fileListStruct.name};
      fileListHndl=findobj(gcf,'Tag','filelistbox');
      set(fileListHndl,'String',fileList);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % end file selection Actions
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % begin fitspectra Actions
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     case 'B0SliderMove'
      global params spectrum;
      set(findobj('Tag','B0Size'), ...
	  'String', get(gcbo,'Value'));
      params(1)=get(gcbo,'Value');
      myPlot(params,spectrum);
      
    
      
     case 'B0SliderRange'
      if strcmp(get(findobj('Tag','minB0'),'String'),'error') | ...
	    strcmp(get(findobj('Tag','maxB0'),'String'), 'error')
      
      elseif eval(get(findobj('Tag','minB0'),'String')) >= ...
	    eval(get(findobj('Tag','maxB0'),'String')) ...
	    set(gcbo,'String','error');
      else
	set(findobj('Tag','B0Slider'),'Min', ...
			  eval(get(findobj('Tag','minB0'),'String')));
	set(findobj('Tag','B0Slider'),'Max', ...
			  eval(get(findobj('Tag','maxB0'),'String')));
	set(findobj('Tag','B0Slider'),'Value', ...
			  (eval(get(findobj('Tag','minB0'),'String'))+...
			   eval(get(findobj('Tag','maxB0'),'String')))/2);
	set(findobj('Tag','B0Size'), ...
	    'String', get(findobj('Tag','B0Slider'),'Value'));
      end
      
     case 'B1SliderMove'
      global params spectrum;
      set(findobj('Tag','B1Size'), ...
	  'String', get(gcbo,'Value'));
      params(2)=get(gcbo,'Value');
      myPlot(params,spectrum);
    
     case 'B1SliderRange'
      if strcmp(get(findobj('Tag','minB1'),'String'),'error') | ...
	    strcmp(get(findobj('Tag','maxB1'),'String'), 'error')
      
      elseif eval(get(findobj('Tag','minB1'),'String')) >= ...
	    eval(get(findobj('Tag','maxB1'),'String')) ...
	    set(gcbo,'String','error');
      else
	set(findobj('Tag','B1Slider'),'Min', ...
			  eval(get(findobj('Tag','minB1'),'String')));
	set(findobj('Tag','B1Slider'),'Max', ...
			  eval(get(findobj('Tag','maxB1'),'String')));
	set(findobj('Tag','B1Slider'),'Value', ...
			  (eval(get(findobj('Tag','minB1'),'String'))+...
			   eval(get(findobj('Tag','maxB1'),'String')))/2);
	set(findobj('Tag','B1Size'), ...
	    'String', get(findobj('Tag','B1Slider'),'Value'));
      end
      
     case 'CSliderMove'
      global params spectrum;
      set(findobj('Tag','CSize'), ...
	  'String', get(gcbo,'Value'));
      params(4*(get(findobj('tag','changePeakPop'),'Value')-1)+3)=get(gcbo,'Value');
      myPlot(params,spectrum);
            
    
     case 'CSliderRange'
      if strcmp(get(findobj('Tag','minC'),'String'),'error') | ...
	    strcmp(get(findobj('Tag','maxC'),'String'), 'error')
      
      elseif eval(get(findobj('Tag','minC'),'String')) >= ...
	    eval(get(findobj('Tag','maxC'),'String')) ...
	    set(gcbo,'String','error');
      else
	    set(findobj('Tag','CSlider'),'Min', ...
			    eval(get(findobj('Tag','minC'),'String')));
	    set(findobj('Tag','CSlider'),'Max', ...
			    eval(get(findobj('Tag','maxC'),'String')));
	    set(findobj('Tag','CSlider'),'Value', ...
			    (eval(get(findobj('Tag','minC'),'String'))+...
			    eval(get(findobj('Tag','maxC'),'String')))/2);
	    set(findobj('Tag','CSize'), ...
	            'String', get(findobj('Tag','CSlider'),'Value'));
      end
      
     case 'DSliderMove'
      global params spectrum;
      set(findobj('Tag','DSize'), ...
	  'String', get(gcbo,'Value'));
      params(4*(get(findobj('tag','changePeakPop'),'Value')-1)+4)=get(gcbo,'Value');
      myPlot(params,spectrum);
    
     case 'DSliderRange'
      if strcmp(get(findobj('Tag','minD'),'String'),'error') | ...
	    strcmp(get(findobj('Tag','maxD'),'String'), 'error')
      
      elseif eval(get(findobj('Tag','minD'),'String')) >= ...
	    eval(get(findobj('Tag','maxD'),'String')) ...
	    set(gcbo,'String','error');
      else
	set(findobj('Tag','DSlider'),'Min', ...
			  eval(get(findobj('Tag','minD'),'String')));
	set(findobj('Tag','DSlider'),'Max', ...
			  eval(get(findobj('Tag','maxD'),'String')));
	set(findobj('Tag','DSlider'),'Value', ...
			  (eval(get(findobj('Tag','minD'),'String'))+...
			   eval(get(findobj('Tag','maxD'),'String')))/2);
	set(findobj('Tag','DSize'), ...
	    'String', get(findobj('Tag','DSlider'),'Value'));
      end
      
     case 'GamSliderMove'
      global params spectrum;
      set(findobj('Tag','GamSize'), ...
	  'String', get(gcbo,'Value'));
      params(4*(get(findobj('tag','changePeakPop'),'Value')-1)+5)=get(gcbo,'Value');
      myPlot(params,spectrum);
    
     case 'GamSliderRange'
      if strcmp(get(findobj('Tag','minGam'),'String'),'error') | ...
	    strcmp(get(findobj('Tag','maxGam'),'String'), 'error')
      
      elseif eval(get(findobj('Tag','minGam'),'String')) >= ...
	    eval(get(findobj('Tag','maxGam'),'String')) ...
	    set(gcbo,'String','error');
      else
	set(findobj('Tag','GamSlider'),'Min', ...
			  eval(get(findobj('Tag','minGam'),'String')));
	set(findobj('Tag','GamSlider'),'Max', ...
			  eval(get(findobj('Tag','maxGam'),'String')));
	set(findobj('Tag','GamSlider'),'Value', ...
			  (eval(get(findobj('Tag','minGam'),'String'))+...
			   eval(get(findobj('Tag','maxGam'),'String')))/2);
	set(findobj('Tag','GamSize'), ...
	    'String', get(findobj('Tag','GamSlider'),'Value'));
      end
      
     case 'FreqSliderMove'
      global params spectrum;
      set(findobj('Tag','FreqSize'), ...
	  'String', get(gcbo,'Value'));
      params(4*(get(findobj('tag','changePeakPop'),'Value')-1)+6)=get(gcbo,'Value');
      myPlot(params,spectrum);
      
    
     case 'FreqSliderRange'
      if strcmp(get(findobj('Tag','minFreq'),'String'),'error') | ...
	    strcmp(get(findobj('Tag','maxFreq'),'String'), 'error')
      
      elseif eval(get(findobj('Tag','minFreq'),'String')) >= ...
	    eval(get(findobj('Tag','maxFreq'),'String')) ...
	    set(gcbo,'String','error');
      else
	set(findobj('Tag','FreqSlider'),'Min', ...
			  eval(get(findobj('Tag','minFreq'),'String')));
	set(findobj('Tag','FreqSlider'),'Max', ...
			  eval(get(findobj('Tag','maxFreq'),'String')));
	set(findobj('Tag','FreqSlider'),'Value', ...
			  (eval(get(findobj('Tag','minFreq'),'String'))+...
			   eval(get(findobj('Tag','maxFreq'),'String')))/2);
	set(findobj('Tag','FreqSize'), ...
	    'String', get(findobj('Tag','FreqSlider'),'Value'));
      end
      
     
     case 'getPeaks'
      global spectrum;
      global params;
      
      [x,y] = ginput;
      myXLim = get(gca,'XLim');
     
      
  
      % Call to plotting function
      % Guess initial parameters
      % Make call to bw function, and plot the initial guess
      if spectrum.col == 1
	start=getPosition(spectrum.one,myXLim(1));
	stop=getPosition(spectrum.one,myXLim(2));
	spectrum.oneTrunc = spectrum.one(start:stop);
	params = getInitialParams(x,spectrum.oneTrunc);
	data = bw(params,[0:1:length(spectrum.oneTrunc)]);
	hold on;
	plot([0:1:length(spectrum.oneTrunc)],data,'r-');
      else
	start=getPosition(spectrum.one,myXLim(1));
	%fprintf('start is: %f\n',start);
	stop=getPosition(spectrum.one,myXLim(2));
	%fprintf('stop is: %f\n',stop);
	spectrum.oneTrunc = spectrum.one(start:stop);
	spectrum.twoTrunc = spectrum.two(start:stop);
	params = getInitialParams(x,spectrum.oneTrunc,spectrum.twoTrunc);
	%fprintf('params is: %f\n',params);
	data = bw(params,spectrum.oneTrunc);
	%size(data)
	hold on;
	plot(spectrum.oneTrunc, data,'r-');
      end
    
      % Set the parameter choice popup box with the correct string
      newString = '1';
      for i=2:length(x)
	newString = strcat(newString,'|',num2str(i));
      end
      set(findobj('Tag','changePeakPop'),'String',newString);
      set(findobj('Tag','changePeakPop'),'Value',1);
      
      
      % Put parameters of peak 1 on sliders and slider text, set ranges
      setParamSliders(params,1);
      set(findobj('Tag','fitButton'),'Enable','on');
      
      
     
     case 'changePeakParams'
      global params;
      setParamSliders(params,get(gcbo,'Value'));
      
      
     
     case 'fitButton'
      global params spectrum;
      
      set(findobj('Tag','saveButton'),'Enable','on');
      myxlim = get(gca,'XLim');    % this code grabs the data within
      myylim = get(gca,'YLim');    % the current zoom box.  the effects

      delete(findobj(gca,'color','red'));
      
      % do the fit and update the parameters in spectrum.
      if(spectrum.datalen > 0)
	for j=1:10  % loop to do better fit
	  if spectrum.col == 1
	    newparams = fit(params,spectrum.oneTrunc,[0:1:length(spectrum.oneTrunc)]);
	    data = bw(newparams,[0:1:length(spectrum.oneTrunc)]);
	    plot([0:1:length(spectrum.oneTrunc)],data,'r-');
	  else
	    newparams = fit(params,spectrum.twoTrunc,spectrum.oneTrunc);
	    data = bw(newparams,spectrum.oneTrunc);
	    
	  end
	  
	  if get(findobj('tag','iterativeFitButton'),'value') == 1
	    params = newparams;
	    setParamSliders(params,get(findobj('tag','changePeakPop'),'Value'))
	  end
	end
	plot(spectrum.oneTrunc, data,'r-');
		
      else 
	sprintf('no data to fit yet \n')
	return
      end
      
      
      
      
     case 'saveButton'
      global params spectrum;
      params=params';
      datf=[];
      datg=[];
      for i=1:(size(params,1)-2)/4
	    fr = params(4*(i-1) + 6);%16.8f
        gam = fr/params(4*(i-1) + 5);
	datf = [datf; [fr 1.]]
        datg = [datg; [fr gam]]
      end
      
      paramFile = strcat(spectrum.filename,'.params');
      fqFile = strcat(spectrum.filename,'.fq');
      fFile = strcat(spectrum.filename,'.f');
      
      %parameter file
      fid = fopen(paramFile,'a+' );
      [paramsRead,count] = fscanf(fid,'%16.8f',inf);
      fprintf(fid,'%16.8f\n',params);
      fclose(fid);
     
      %F and Q file
      %read in all the elements
      fid = fopen(fqFile,'a+' );
      %num = fgetl(fid)
      [fqRead,count] = fscanf(fid,'%16f  %16f',[2,inf]);
      if count ~= 0
        %sort before writing
        toSort = [fqRead';datg;];
        sortedFQ = sortrows(toSort)';
        num = size(toSort,1);
        fclose(fid);
        fid = fopen(fqFile,'w' );
      else
        num = size(datg,1);
        sortedFQ = datg';
      end
      %fprintf(fid,'%16.8f\n',num);
      fprintf(fid,'%16.8f  %16.8f\n',sortedFQ);
      fclose(fid);
      
      %Save only frequencies (with 1 weight) for inversion
      fid = fopen(fFile,'a+' );
      num = fgetl(fid);
      [fRead,count] = fscanf(fid,'%16f  %16f',[2,inf]);
      if count ~= 0
        %sort before writing
        toSort = [fRead';datf];
        sortedF = sortrows(toSort)';
        num = size(toSort,1);
        fclose(fid);
        fid = fopen(fFile,'w' );
      else
        num = size(datf,1);
        sortedF = datf';
      end
      fprintf(fid,'%16.8f\n',num);
      fprintf(fid,'%16.8f %16.8f\n',sortedF);
      fclose(fid);
      
      set(findobj('Tag','saveButton'),'Enable','off');
      set(findobj('Tag','fitButton'),'Enable','off');
      %set(findobj('Tag','peakButton'),'Enable','off');
      
      
      
      
     otherwise  % This should never happen...
      msgbox(['Unknown Action: ' Action], 'fitspectra', 'error');
    end
  end
  
  
