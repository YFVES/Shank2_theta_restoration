function Redraw(self)
%
% MClustMainWindow: redraw

MCD = MClust.GetData();
MCS = MClust.GetSettings();

set(self.LoadingEnginePulldown, 'String', self.LoadingEngines, 'Value', self.LoadingEngineValue);

self.FeatureListBoxes.SetLeftList(setdiff(MCS.FeaturesAvailable, MCS.FeaturesToUse));
self.FeatureListBoxes.SetRightList(MCS.FeaturesToUse);

for iV = 1:MCS.nCh
    set(self.ChannelValidityButton{iV}, 'Value', MCS.ChannelValidity(iV));
end

if isempty(MCD.FeatureTimestamps)
    set(self.TTfnLabel, 'String', '', 'BackgroundColor', [0.5 0.5 0.5]);
    set(self.FDCheckBox, 'Value', false);
else
    set(self.TTfnLabel, 'String', MCD.TTfn, 'BackgroundColor', 'c');
    set(self.FDCheckBox, 'Value', true);
end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   function OK = WriteTfiles(self)

% Write T files (MClustData)

% ADR 2014-12-17
% now calls EraseTfiles to erase T files (so includes WV and CQ as well)
% now asks if want to erase if save with no clusters and there are previous
% .t or ._t files.

MCS = MClust.GetSettings();
MCD = self;

% ADR 2008 - delete .t set if replacing
fcT = FindFiles([MCD.TTfn '_*.t'], 'StartingDirectory', MCD.TTdn, 'CheckSubdirs', 0);
fc_T = FindFiles([MCD.TTfn '_*._t'], 'StartingDirectory', MCD.TTdn, 'CheckSubdirs', 0);
fc = cat(1, fcT, fc_T);

% ADR 2014-12-17
if isempty(MCD.Clusters)
    if ~isempty(fc)
        reply = questdlg({'There are no clusters, but there are previous .t or ._t files for this tetrode.','Do you want to erase them?'},...
            'Erase t files?', 'Yes', 'Cancel', 'Yes');
        if streq(reply, 'Yes')
            self.EraseTfiles();
        else
            OK = false;
            return
        end
    else
        OK = false;
        msgbox('There are no clusters to write.', 'WriteTFiles','warn');
        return
    end
end
  
% some of the clusters may be _t
if MCS.UseUnderscoreT
    names = cellfun(@(x)x.name, MCD.Clusters, 'UniformOutput', false);
    underscoreTclusters = listdlg(...
        'ListString', names, ...
        'Name', 'Files to save as _t', ...
        'PromptString', 'Which clusters should be saved as with an "_t" extension?', ...
        'OKString', 'DONE', 'CancelString', 'No _t files.', ...
        'InitialValue', []);    
else
    underscoreTclusters = [];
end

nClust = length(MCD.Clusters);

if ~isempty(fc)
	reply = questdlg({'There are already .t or ._t files for this tetrode.','Do you want to replace them?'},...
		'Overwrite t files?', 'Yes', 'Cancel', 'Yes');
	if streq(reply, 'Yes')
        self.EraseTfiles();
	else
		OK = false;
		return
	end
end
for iC = 1:nClust
   spikes = MCD.Clusters{iC}.GetSpikes();
   if ~isempty(spikes)
       
      tSpikes = MCD.FeatureTimestamps(spikes);
      
      if ismember(iC, underscoreTclusters)
          fn = [MCD.TfileBaseName(iC) '._' MCS.tEXT];
      else
          fn = [MCD.TfileBaseName(iC) '.' MCS.tEXT];
      end            
      
      fp = fopen(fn, 'wb', 'b');
      if (fp == -1)
         errordlg(['C