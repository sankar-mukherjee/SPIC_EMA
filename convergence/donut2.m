function donout = donut2(numdat,clrmp,gender)
% numdat: number data. Each column is a catagory, each row represents
%   a separate set of data
% varargin{1}: cell of legend entries, one string for each column of numdat,
%   default is none, eg. {'First','Second','Third'}
% varargin{2}: cell of colors, one row of 3 RGB values for each category (column of numdat)
% varargin{3}: if 'pie', will make a standard pie chart
% Examples:
%   donut([50,20,10;40,30,15],{'First','Second','Third'},{'r','g','b'});
%   donut([50,20,10],{'First','Second','Third'},[],'pie');
%   donut([50,20,10;40,30,15],[],{[ .945 .345 .329],[ .376 .741 .408],[ .365 .647 .855 ]});

% Default Values, if no variable arguments in
% legtext = [];
% colormap lines
% clrmp = colormap;
% ispie = 0;
% 
% if length(varargin)>0
%     legtext = varargin{1};
%     if length(varargin)>1
%         if ~isempty(varargin{2})
%             clrmp = varargin{2};
%         else
%             colormap lines
%             clrmp = colormap;
%         end
%         if length(varargin)>2
%             if isempty(find(strcmp(varargin,'pie')))==0; ispie = 1; end
%         end
%     end
% end

rings = size(numdat,1); % nuber of rings in plot
cats = size(numdat,2); % number of categories in each ring/set

donout = nan(size(numdat));
k=1;
for i = 1:rings
    tot = nansum(numdat(i,:)); % total things
    donout(i,:)=numdat(i,:)./tot;
    fractang = (pi/2)+[0,cumsum((numdat(i,:)./tot).*(2*pi))];
    for j = 1:cats
        r0 = k;
        r1 = k+0.95;
        a0 = fractang(j);
        a1 = fractang(j+1);
        if iscell(clrmp)
            cl = clrmp{j};
        else
            cl = clrmp(j,:);
        end
        if(j==1)
            X = 111;
        else
            X = i;
        end
        polsect(a0,a1,r0,r1,cl,X,gender(i));
    end
    if(mod(i,2)==0)
        k=k+1.5;
    else
        k=k+1;
    end
end

function pspatch = polsect(th0,th1,rh0,rh1,cl,txt,g)
% This function creates a patch from polar coordinates

a1 = linspace(th0,th0);
r1 = linspace(rh0,rh1);
a2 = linspace(th0,th1);
r2 = linspace(rh1,rh1);
a3 = linspace(th1,th1);
r3 = linspace(rh1,rh0);
a4 = linspace(th1,th0);
r4 = linspace(rh0,rh0);
[X,Y]=pol2cart([a1,a2,a3,a4],[r1,r2,r3,r4]);

p=patch(X,Y,cl,'EdgeColor','none'); % Note: patch function takes text or matrix color def
[xtext,ytext] = pol2cart((th1+th0)/2, ((rh1+rh0)/2));
if not(txt==111)
    text(xtext,ytext,['s' num2str(txt) '-' g{1}],'HorizontalAlignment','center');
end
axis equal
pspatch = p;
