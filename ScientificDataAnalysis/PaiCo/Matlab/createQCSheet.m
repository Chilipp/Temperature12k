
function outcell = createQCSheet(TS)
%create global QCsheet

% climateVariable={TS.climateInterpretation1_variable}';
% useIn={TS.paleoData_useInGlobalTemperatureAnalysis}';
% tempSens=find(strcmp(climateVariable,'T'));
%
% true=find(strcmp(useIn,'TRUE'));
% false=find(strcmp(useIn,'FALSE'));
% other=setdiff(1:length(TS),union(true,false));
varnames = {TS.paleoData_variableName}';
toInclude=find(~strncmpi('year',varnames,4) & ~strncmpi('depth',varnames,5));; %[true];% ;other;  false];

% %determine min and max year
% minYear=nan(length(TS),1);
% maxYear=nan(length(TS),1);
% minYear(find(~cellfun(@iscell,{TS.year}')))=cellfun(@nanmin,{TS(find(~cellfun(@iscell,{TS.year}'))).year}');
% maxYear(find(~cellfun(@iscell,{TS.year}')))=cellfun(@nanmax,{TS(find(~cellfun(@iscell,{TS.year}'))).year}');
% maxYear=num2cell(maxYear);
% minYear=num2cell(minYear);
% [TS.minYear]=minYear{:};
% [TS.maxYear]=maxYear{:};
bc=repmat({' '},length(TS),1);
%create some fields that may not exist
toCreate={'dataPub1_Urldate'};




%get Data Contributor
% dc = stringifyCells({TS.dataContributor}');


%build google data URL
wskeys={TS.googleSpreadSheetKey}';
urlCell=([repmat({'https://docs.google.com/spreadsheets/d/'},length(TS),1) wskeys]);
url=strcat(urlCell(:,1),urlCell(:,2));
toBlank=find(cellfun(@isempty,wskeys));
if ~isempty(toBlank)
    url(toBlank)=repmat({' '},length(toBlank),1);
end
[TS.googleDataURL]=url{:};


if exist('toCreate')
    for i=1:length(toCreate)
        if ~isfield(TS,toCreate{i});
            [TS.(toCreate{i})]=bc{:};
        end
    end
end


if ~isfield(TS,'paleoData_supersededBy')
    bc=repmat({[]},length(TS),1);
    [TS.paleoData_supersededBy]=bc{:};
end
%what to include in the table, and in what order?
QCnames={'TSid','dataSetName','PAGES 2k ID', 'iso2kUI','archiveType',...
    'pub1_citeKey','pub1_authors','pub1_Year',...
    'pub1_DOI','pub1_citation','pub2_citeKey','pub2_authors','pub2_Year','pub2_DOI','pub2_citation',...
    'dataPub1_author','dataPub1_citeKey','dataPub1_institution','dataPub1_year','dataPub1_title','dataPub1_type','dataPub1_url',...
    'lat','long','elevation','sitename','minYear','maxYear',...
    'variableName','units','description','paleoDataNotes','measurementMaterial','measurementMaterialDetail',...
    'Has chronology data','Has paleo depth data',...
    'climateVariable','climateVariableDetail','seasonality','direction','basis',...
    'isotopeInterpretation1_equilibriumEvidence',...
    'isotopeInterpretation1_inferredMaterial',...
    'isotopeInterpretation1_integrationTime','isotopeInterpretation1_integrationTimeBasis',...
    'isotopeInterpretation1_integrationTimeUncertainty','isotopeInterpretation1_integrationTimeUncertaintyType',...
    'isotopeInterpretation1_integrationTimeUnits', ...
    'isotopeInterpretation1_basis',...
    'isotopeInterpretation1_coefficient','isotopeInterpretation1_direction',...
    'isotopeInterpretation1_fraction','isotopeInterpretation1_mathematicalRelation',...
    'isotopeInterpretation1_name','isotopeInterpretation1_rank',...
    'isotopeInterpretation1_seasonality','isotopeInterpretation2_basis',...
    'isotopeInterpretation2_coefficient','isotopeInterpretation2_direction',...
    'isotopeInterpretation2_fraction','isotopeInterpretation2_mathematicalRelation',...
    'isotopeInterpretation2_name','isotopeInterpretation2_rank',...
    'isotopeInterpretation2_seasonality','isotopeInterpretation3_basis',...
    'isotopeInterpretation3_coefficient','isotopeInterpretation3_direction',...
    'isotopeInterpretation3_fraction', 'isotopeInterpretation3_mathematicalRelation',...
    'isotopeInterpretation3_name', 'isotopeInterpretation3_rank',...
    'isotopeInterpretation3_seasonality',...
    'QC comments','QC Certification','link to data'};

shortQCnames={'TSid','dataSetName','PAGES 2k ID', 'iso2kUI','archiveType',...
    'citeKey','authors','Year',...
    'DOI','citation','citeKey','authors','Year','DOI','citation',...
    'author','citeKey','institution','pubYear','title','type','url',...
    'lat','long','elevation','sitename','minYear','maxYear',...
    'variableName','units','description','paleoDataNotes','measurementMaterial','measurementMaterialDetail',...
    'HasChronData','HasPaleoDepthData',...
    'climateVariable','climateVariableDetail','seasonality','direction','basis',...
    'equilibriumEvidence',...
    'inferredMaterial',...
    'integrationTime','integrationTimeBasis',...
    'integrationTimeUncertainty','integrationTimeUncertaintyType',...
    'integrationTimeUnits', ...
    'basis',...
    'coefficient','direction',...
    'fraction','mathematicalRelation',...
    'name','rank',...
    'seasonality','basis',...
    'coefficient','direction',...
    'fraction','mathematicalRelation',...
    'name','rank',...
    'seasonality','basis',...
    'coefficient','direction',...
    'fraction', 'mathematicalRelation',...
    'name', 'rank',...
    'seasonality',...
    'QC comments','QC Certification','link to data'};

QC_TSnames={'paleoData_TSid','dataSetName','paleoData_pages2kID','paleoData_iso2kUI','archiveType'...
    'pub1_citeKey','pub1_author','pub1_year',...
    'pub1_DOI','pub1_citation','pub2_citeKey','pub2_author','pub2_year','pub2_DOI','pub2_citation',...
    'dataPub1_author','dataPub1_citeKey','dataPub1_institution','dataPub1_year','dataPub1_title','dataPub1_type','dataPub1_url',...
    'geo_meanLat','geo_meanLon','geo_meanElev','geo_siteName','minYear','maxYear',...
    'paleoData_variableName','paleoData_units','paleoData_description','paleoData_notes','paleoData_measurementMaterial','paleoData_measurementMaterialDetail',...
    'hasChron','hasPaleoDepth',...
    'climateInterpretation1_variable','climateInterpretation1_variableDetail','climateInterpretation1_seasonality','climateInterpretation1_interpDirection','climateInterpretation1_basis',...
    'isotopeInterpretation1_equilibriumEvidence',...
    'isotopeInterpretation1_inferredMaterial',...
    'isotopeInterpretation1_integrationTime','isotopeInterpretation1_integrationTimeBasis',...
    'isotopeInterpretation1_integrationTimeUncertainty','isotopeInterpretation1_integrationTimeUncertaintyType',...
    'isotopeInterpretation1_integrationTimeUnits', ...
    'isotopeInterpretation1_basis',...
    'isotopeInterpretation1_coefficient','isotopeInterpretation1_direction',...
    'isotopeInterpretation1_fraction','isotopeInterpretation1_mathematicalRelation',...
    'isotopeInterpretation1_variable','isotopeInterpretation1_rank',...
    'isotopeInterpretation1_seasonality','isotopeInterpretation2_basis',...
    'isotopeInterpretation2_coefficient','isotopeInterpretation2_direction',...
    'isotopeInterpretation2_fraction','isotopeInterpretation2_mathematicalRelation',...
    'isotopeInterpretation2_variable','isotopeInterpretation2_rank',...
    'isotopeInterpretation2_seasonality','isotopeInterpretation3_basis',...
    'isotopeInterpretation3_coefficient','isotopeInterpretation3_direction',...
    'isotopeInterpretation3_fraction', 'isotopeInterpretation3_mathematicalRelation',...
    'isotopeInterpretation3_variable', 'isotopeInterpretation3_rank',...
    'isotopeInterpretation3_seasonality',...
    'paleoData_QCnotes','paleoData_QCCertification','googleDataURL'};


% %deal with multiple citations
% cit={TS.pub1_citation}';
% nie=find(cellfun(@iscell,cit));
%
% cit(nie)=cellfun(@(x) x(1),cit(nie));
% %clean strings
% icc=find(cellfun(@isstr,cit));
% cit(icc)=cellfun(@(x) regexprep(x,'[^a-zA-Z0-9-.,: ]',''),cit(icc),'UniformOutput',0);
% [TS.pub1_citation]=cit{:};

%right names?
for i=1:length(QC_TSnames)
    if ~isfield(TS,QC_TSnames{i})
%        error([QC_TSnames{i} ' is not in TS'])
                  [TS.(QC_TSnames{i})]=bc{:};
        
        warning([QC_TSnames{i} ' is not in TS; creating it....'])
    end
end


%create a giant cell
outcell={TS.(QC_TSnames{1})}';

for i=2:length(QC_TSnames)
    toStore={TS.(QC_TSnames{i})}';
    if  any(cellfun(@iscell,toStore))
        toStore=stringifyCells(toStore);
        while size(toStore)>1
            toStore(:,1)=strcat(toStore(:,1),toStore(:,2));
        end
    end
    
    outcell=[outcell toStore];
end
warning('off','all')

%fix unicode issues
outcell=cellfun(@fixUnicodeStr,outcell,'UniformOutput',0);
outcell=[QCnames ; shortQCnames ; outcell(toInclude,:)];

%get rid of any pipes in the cells
outcell=cellfun(@(x) strrep(x,'|',','),outcell,'UniformOutput',0);

%how about any carriage returns
outcell = cellfun(@removeCarriageReturn,outcell,'UniformOutput',0);
warning('on','all')

% checkGoogleTokens;
% newS=createSpreadsheet('GlobalQCNew',aTokenDocs,'default.csv','text/csv');
% wsNames=getWorksheetList(newS.spreadsheetKey,aTokenSpreadsheet);
% changeWorksheetNameAndSize(newS.spreadsheetKey,wsNames(1).worksheetKey,size(outcell,1),size(outcell,2),'QC spreadsheet',aTokenSpreadsheet);

% for i=1:size(outcell,2)
% editWorksheetColumn(newS.spreadsheetKey,wsNames(1).worksheetKey,i,1:size(outcell,1),outcell(:,i),aTokenSpreadsheet);
% end

%cell2csv('~/Dropbox/LiPD/iso2k/QC0.5.txt',outcell,'|')


