clc; clear; close all;

%% exp(x) about 0
titleName = "exp(x) about 0";
func = @(x) exp(x);
expansionPoint = 0;
domain = [-5 5];
maxOrder = 20;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% exp(x) about 1
titleName = "exp(x) about 1";
func = @(x) exp(x);
expansionPoint = 1;
domain = [-5 5];
maxOrder = 20;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% tanh(x) about 0
titleName = "tanh(x) about 0";
func = @(x) tanh(x);
expansionPoint = 0;
domain = [-5 5];
maxOrder = 25;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% tanh(x) about 0.5
titleName = "tanh(x) about 0.5";
func = @(x) tanh(x);
expansionPoint = 0.5;
domain = [-5 5];
maxOrder = 30;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% arctan(x) about 0
titleName = "arctan(x) about 0";
func = @(x) atan(x);
expansionPoint = 0;
domain = [-5 5];
maxOrder = 30;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% arctan(x) about 0.5
titleName = "arctan(x) about 0.5";
func = @(x) atan(x);
expansionPoint = 0.5;
domain = [-5 5];
maxOrder = 30;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% 1/x about 0.5
titleName = "1/x about 0.5";
func = @(x) 1./x;
expansionPoint = 0.5;
domain = [-5 5];
maxOrder = 30;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% 1/(x-1) about 0.75
titleName = "1/(x-1) about 0.75";
func = @(x) 1./(x-1);
expansionPoint = 0.75;
domain = [-5 5];
maxOrder = 30;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% sin(x) about 0
titleName = "sin(x) about 0";
func = @(x) sin(x);
expansionPoint = 0;
domain = [-5 5];
maxOrder = 30;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% sin(x) about 0.5
titleName = "sin(x) about 0.5";
func = @(x) sin(x);
expansionPoint = 0.5;
domain = [-5 5];
maxOrder = 30;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% x/(x^2 + 0.01^2)^(1/4)
titleName = "x/(x^2 + 0.01^2)^(1/4) about 0.5";
func = @(x) x./(x.^2 + 0.01^2).^(1/4);
expansionPoint = 0.5;
domain = [-5 5];
maxOrder = 30;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% Runge function
titleName = "Runge function, 1/(1+25*x^2) about 0";
func = @(x) 1./(1+25*x.^2);
expansionPoint = 0;
domain = [-5 5];
maxOrder = 20;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% Runge function
titleName = "Runge function, 1/(1+25*x^2) about 0.5";
func = @(x) 1./(1+25*x.^2);
expansionPoint = 0.5;
domain = [-5 5];
maxOrder = 20;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%%
function createVideo(titleName,func,expansionPoint,domain,maxOrder,approach)

    arguments
        titleName (1,1) string;
        func (1,1) function_handle;
        expansionPoint (1,1) double;
        domain (1,2) double;
        maxOrder (1,1);
        approach (1,1) string {mustBeMember(approach,["chebfun","sym"])} = "sym";
    end
    
    
% setup figure
width = 1920;
height = 1080;
figureObject = figure("Position",[10 10 width height]);

% setup video file
videoName = regexprep(titleName,["/","\*"],"_") + ".mp4";
video = VideoWriter(videoName,"MPEG-4");
video.FrameRate = 2;

try
    video.open();

    % setup function to approximate
    fplot(func,domain,"linewidth",3,"DisplayName",func2str(func))
    hold all;
    xlabel("x"); ylabel("y")
    title(titleName)
    ylim(ylim);
    xlim(xlim);
    
    % find the permutations of the numerator and denominator
    [numeratorOrder, denominatorOrder] = ndgrid(0:maxOrder,0:maxOrder);
    totalOrder = numeratorOrder + denominatorOrder;
    isOrderToHigh = totalOrder > maxOrder;
    numeratorOrder(isOrderToHigh) = [];
    denominatorOrder(isOrderToHigh) = [];
    [~,sortedIndex] = sortrows([denominatorOrder(:)+numeratorOrder(:), numeratorOrder(:), denominatorOrder(:)]);
    numeratorOrder = numeratorOrder(sortedIndex);
    denominatorOrder = denominatorOrder(sortedIndex);
    
    
    % loop
    for i=1:length(numeratorOrder)
        % calculate next pade approximant
        order = [numeratorOrder(i), denominatorOrder(i)];
        switch approach
            case "chebfun"
                
                % padeapprox is used from  the Chebfun toolbox by Trefethen and others. The advantage is computation is
                % faster then symbolic computation. The disadvantage is has numerical issues at total order
                % (numeratorOrder + denominatorOrder) of 16 or so.
                %
                % http://www.chebfun.org/
                % P. Gonnet, S. Guettel, and L. N. Trefethen, "Robust Pade approximation  via SVD", SIAM Rev., 55:101-117, 2013.
                %
                % Commentary: numerical issues are more of a statement of ill-conditioning of monomial basis combined
                % with constructing a pade approximate. Finding a pade approximate may be possible via an orthogonal
                % polynomial basis but I am not aware of any software that does this.
                % 
                padeApproximant = padeapprox(@(x) func(x+expansionPoint), order(1),order(2));
                padeApproximant = @(x) padeApproximant(x-expansionPoint);
            case "sym"
                % The symbolic approach is accurate but slow. For high enough total order (numeratorOrder +
                % denominatorOrder), large integer errors occur stopping further computation. To avoid this as much as
                % possible, we try to tell the symbolic engine that we want variable precision arithmetic, vpa().
                if i==1
                    syms x real
                    digits(20);
                    func = vpa(func(vpa(1.0)*x));
                end
                padeApproximant = pade(func, x, expansionPoint, 'order', order);
        end
        
        
        label = sprintf("Padé approximant, Pade Order = [%3d,%3d],Total Order = %3d",order,sum(order));
        if i ==1
            % setup plot
            fplotObject = fplot(padeApproximant,"--","LineWidth",3,"DisplayName",label);
            legend("location","best");
        else
            % plot
            fplotObject.Function = padeApproximant;
            fplotObject.DisplayName = label;
        end
        % write frame
        video.writeVideo(getframe(figureObject));
    end

    video.close();
catch e  %#ok
    video.close();
    fprintf("%s around %g failed at pade order = [%d, %d]\n",string(func),expansionPoint,order(1),order(2));
%     if exist(videoName,"file")
%         delete(videoName);
%     end
     rethrow(e);
end

end
