function moviemaker_trees(S,P,folder)

%% Calculate tetrahedron

a = P.side_tetrahedron;
x1 = P.apex_tetrahedron(1);
y1 = P.apex_tetrahedron(2);
z1 = P.apex_tetrahedron(3);

x2 = x1;
y2 = y1 + a;
z2 = z1;

x3 = x1 + a * sqrt(3/4);
y3 = y1 + a/2;
z3 = z1;

A = [x1, y1, z1];
B = [x2, y2, z2];
C = [x3, y3, z3];

color = [
    0 0 0;
    0 0 0;
    0 0 0;
    1 0 0];

%% Make movie

% Initialize video
fps = 10;
quality = 100; % 0-100

outfile = [folder, S.pop_ID];
%V = VideoWriter(outfile,'MPEG-4');
V = VideoWriter([outfile,'.avi']);

V.FrameRate = fps;
V.Quality = quality;
open(V);

% Create figure
scrsz = get(0,'ScreenSize');
x=0.9;
f = figure('Position',[1 1 scrsz(3)*x scrsz(4)*x]); % 1 1 scrsz(3) scrsz(4)
%f=figure;
set(gcf,'Renderer','zbuffer');

for g = 1:S.nbof_generations
   
    D = S.best_positionD(g,:);
    tetrahedron = [A;B;C;D];
    
    scatter3(tetrahedron(:,1), tetrahedron(:,2), tetrahedron(:,3), 100, color, 'fill')
    hold;
    plot3([A(1),B(1)], [A(2),B(2)], [A(3),B(3)], 'k')
    plot3([A(1),C(1)], [A(2),C(2)], [A(3),C(3)], 'k')
    plot3([B(1),C(1)], [B(2),C(2)], [B(3),C(3)], 'k')
    
    plot3([A(1),D(1)], [A(2),D(2)], [A(3),D(3)], 'k')
    plot3([B(1),D(1)], [B(2),D(2)], [B(3),D(3)], 'k')
    plot3([C(1),D(1)], [C(2),D(2)], [C(3),D(3)], 'k')

    
    xlim([0 100])
    ylim([0 100])
    zlim([0 100])
    title(['Generation ', num2str(g)])
    hold off
       
    writeVideo(V, getframe(f));
    
end
close(V);
close



