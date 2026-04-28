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
maxOrder = 21;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%% tanh(x) about 0
titleName = "tanh(x) about 0";
func = @(x) tanh(x);
expansionPoint = 0;
domain = [-5 5];
maxOrder = 50;
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

%% sqrt(abs(x))*sign(x) about 0.5
titleName = "sqrt(abs(x))*sign(x) about 0.5";
func = @(x) sqrt(abs(x)).*sign(x);
expansionPoint = 0.5;
domain = [-5 5];
maxOrder = 40;
createVideo(titleName, func, expansionPoint, domain, maxOrder);

%%
function createVideo(titleName,func,expansionPoint,domain,maxOrder)

% setup figure
figureObject = figure("Position",[10 10 1920 1080]);

% setup video file
videoName = regexprep(titleName,"/","_") + ".avi";
video = VideoWriter(videoName,"Motion JPEG AVI");
video.FrameRate = 2;

try
    video.open();

    % setup function to approximate
    fplot(func,domain,"linewidth",3,"DisplayName",func2str(func))
    hold all;
    xlabel("x"); ylabel("y")
    title(titleName)
    ylim(ylim);

    syms x real;
    taylor = func(expansionPoint);
    fplotObject = fplot(taylor,"--","LineWidth",3,"DisplayName",sprintf("Taylor Series, Order = %3d",0));
    legend("location","best");
    video.writeVideo(getframe(figureObject));

    % loop
    deriv = diff(func(x),x);
    factorial = sym('1');
    for i=1:maxOrder
        % add next term to taylor series
        derivativeAtExpansionPoint = subs(deriv,x,expansionPoint);
        factorial = factorial*i;
        taylor = taylor + derivativeAtExpansionPoint./factorial*(x-expansionPoint).^i;

        % plot
        fplotObject.Function = taylor;
        fplotObject.DisplayName = sprintf("Taylor Series, Order = %3d",i);

        % write frame
        video.writeVideo(getframe(figureObject));

        % setup for next loop
        deriv = diff(deriv,x);
    end

    video.close();
catch e
    video.close();
    if exist(videoName,"file")
        delete(videoName);
    end
    rethrow(e);
end

end
