clear
close all

fig = figure('Position',[100 200 800 400]);

g = 9.8; % Acceleration of gravity

% Plant Setting
n = 20; % gear ratio
J = 100; % moment of inertia
k = 10; % Positive constant

% Governor Setting
omega0 = 0; % Initial angular velocity of rotating shaft
phi0 = pi/4; % Initial opening angle of arms (Target angle)
dphi0 = 0; % Initial opening angular velocity of arms

L = 10; % Length of arms
beta = 7; % Positive constant

% Simulation with Simulink
t_end = 200; % Simulation time
out = sim('governor_simulink.slx');

% Animation
tiledlayout(2,5)
nexttile(1,[2 3])

omega = 0.1*out.omega.Data;
phi = out.phi.Data;


[X_cy,Y_cy,Z_cy] = cylinder(0.15);

Z_cy = L*Z_cy;

cy1 = surf(X_cy,Y_cy,Z_cy);
cy1.EdgeAlpha = 0;
cy1.FaceColor = 'r';
rotate(cy1,[0 1 0],phi(1)*180/pi,[0 0 L])

hold on

cy2 = surf(X_cy,Y_cy,Z_cy);
cy2.EdgeAlpha = 0;
cy2.FaceColor = 'b';
rotate(cy2,[0 1 0],-phi(1)*180/pi,[0 0 L])


cy_ax = surf(X_cy,Y_cy,Z_cy);
cy_ax.EdgeAlpha = 0;
cy_ax.FaceColor = 'k';
cy_ax.ZData(1,:) = cy_ax.ZData(1,:) - 4;

cy3 = surf(X_cy,Y_cy,Z_cy*0.5 + L*(1-cos(phi(1))));
cy3.EdgeAlpha = 0;
cy3.FaceColor = 'r';
v = [(mean(cy1.XData(1,:)) - mean(cy2.XData(1,:))) (mean(cy1.YData(1,:)) - mean(cy2.YData(1,:))) (mean(cy1.ZData(1,:)) - mean(cy2.ZData(1,:)))];
v = v*[0 -1 0; 1 0 0; 0 0 1];
rotate(cy3,v,-phi(1)*180/pi,[0 0 L*(1-cos(phi(1)))])

cy4 = surf(X_cy,Y_cy,Z_cy*0.5 + L*(1-cos(phi(1))));
cy4.EdgeAlpha = 0;
cy4.FaceColor = 'b';
rotate(cy4,v,phi(1)*180/pi,[0 0 L*(1-cos(phi(1)))])

[X_sph,Y_sph,Z_sph] = sphere(30);

sph1 = surf(X_sph,Y_sph,Z_sph);
sph1.EdgeAlpha = 0;
sph1.FaceColor = 'r';

sph1.XData = sph1.XData + mean(cy1.XData(1,:));
sph1.YData = sph1.YData + mean(cy1.YData(1,:));
sph1.ZData = sph1.ZData + mean(cy1.ZData(1,:));


sph2 = surf(X_sph,Y_sph,Z_sph);
sph2.EdgeAlpha = 0;
sph2.FaceColor = 'b';


sph2.XData = sph2.XData + mean(cy2.XData(1,:));
sph2.YData = sph2.YData + mean(cy2.YData(1,:));
sph2.ZData = sph2.ZData + mean(cy2.ZData(1,:));

theta = linspace(0,pi*3/2,100);
p1 = plot3(cos(theta),sin(theta),-3.5*ones(size(theta)),'LineWidth',1.5,'Color',[0.4660 0.6740 0.1880]);
p2 = plot3([0 -1/2],[-1 -1/2],-3.5*ones(2,1),'LineWidth',1.5,'Color',[0.4660 0.6740 0.1880]);
p3 = plot3([0 -1/2],[-1 -3/2],-3.5*ones(2,1),'LineWidth',1.5,'Color',[0.4660 0.6740 0.1880]);

text(-2.5,0,-3.5,'$\omega$','Interpreter','latex','FontSize',15)


theta2 = linspace(-pi/2,-pi/2 + phi(1),100);
theta2plot = plot3(2*cos(theta2),zeros(size(theta2)),L + 2*sin(theta2),'k','LineWidth',1);

p4 = patch([0 2*cos(theta2)],[0 zeros(size(theta2))],[L L + 2*sin(theta2)],'m');
p4.FaceAlpha = 0.2;

txt = text(1,0,L-3,'$\phi$','Interpreter','latex','FontSize',15);

set(gca,"XColor",'none','YColor','none','ZColor','none')
axis([-L L -L L -4 L*1.2])
daspect([1 1 1])
view(20,20)
camlight

% figure1(phi)
nexttile(4,[1 2])
phi_plot = plot(out.phi.Time(1:end), out.phi.Data(1:end),'m','LineWidth',1.5);

xlim([0 inf])
ylim([min(out.phi.Data)*0.9 max(out.phi.Data)*1.1])

xlabel('$t$','Interpreter','latex','FontSize',15)
ylabel('$\phi$','Interpreter','latex','FontSize',15)
title([])
set(gca,'TickLabelInterpreter','latex')

% figure2(omega)
nexttile(9,[1 2])
omega_plot = plot(out.omega.Time(1:end),out.omega.Data(1:end),'LineWidth',1.5,'Color',[0.4660 0.6740 0.1880]);

xlim([0 inf])
ylim([0 max(out.omega.Data)*1.1])

xlabel('$t$','Interpreter','latex','FontSize',15)
ylabel('$\omega$','Interpreter','latex','FontSize',15)
title([])
set(gca,'TickLabelInterpreter','latex')


set(gca, 'LooseInset', get(gca, 'TightInset'))

% Update each animation
% video = VideoWriter("governor_animation.avi",'Uncompressed AVI');
% open(video)
for i = 2:length(phi)
    rotate(cy1,[0 0 1],omega(i)*180/pi,[0 0 L])
    rotate(cy2,[0 0 1],omega(i)*180/pi,[0 0 L])

    rotate(sph1,[0 0 1],omega(i)*180/pi,[0 0 L])
    rotate(sph2,[0 0 1],omega(i)*180/pi,[0 0 L])

    cy3.XData = X_cy;
    cy3.YData = Y_cy;
    cy3.ZData = Z_cy*0.5 + L*(1-cos(phi(i)));
    cy4.XData = X_cy;
    cy4.YData = Y_cy;
    cy4.ZData = Z_cy*0.5 + L*(1-cos(phi(i)));


    v = [(mean(cy1.XData(1,:)) - mean(cy2.XData(1,:))) (mean(cy1.YData(1,:)) - mean(cy2.YData(1,:))) (mean(cy1.ZData(1,:)) - mean(cy2.ZData(1,:)))];
    v = v*[0 -1 0; 1 0 0; 0 0 1];
    rotate(cy3,v,-phi(i)*180/pi,[0 0 L*(1-cos(phi(i)))])
    rotate(cy4,v,phi(i)*180/pi,[0 0 L*(1-cos(phi(i)))])

    rotate(cy1,v,-(phi(i-1) - phi(i))*180/pi,[0 0 L])
    rotate(cy2,v,(phi(i-1) - phi(i))*180/pi,[0 0 L])
    rotate(sph1,v,-(phi(i-1) - phi(i))*180/pi,[0 0 L])
    rotate(sph2,v,(phi(i-1) - phi(i))*180/pi,[0 0 L])

    phi_plot.XData = out.phi.Time(1:i);
    phi_plot.YData = out.phi.Data(1:i);

    omega_plot.XData = out.omega.Time(1:i);
    omega_plot.YData = out.omega.Data(1:i);

    theta2 = linspace(-pi/2,-pi/2 + phi(i),100);
    theta2plot.XData = 2*cos(theta2);
    theta2plot.YData = zeros(size(theta2));
    theta2plot.ZData = L + 2*sin(theta2);

    p4.XData = [0 2*cos(theta2)];
    p4.YData = [0 zeros(size(theta2))];
    p4.ZData = [L L + 2*sin(theta2)];

    rotate(p1,[0 0 1],omega(i)*180/pi,[0 0 -3.5])
    rotate(p2,[0 0 1],omega(i)*180/pi,[0 0 -3.5])
    rotate(p3,[0 0 1],omega(i)*180/pi,[0 0 -3.5])

    rotate(theta2plot,[0 0 1],sum(omega(1:i))*180/pi,[0 0 L])
    rotate(p4,[0 0 1],sum(omega(1:i))*180/pi,[0 0 L])
    rotate(txt,[0 0 1],omega(i)*180/pi,[0 0 L])

    drawnow
%     frame = getframe(gcf);
%     writeVideo(video,frame)
end
% close(video)