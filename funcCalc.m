function []=funcCalc(l,p,sigma,N, savePath)


alpha=30 *(pi/180);
beta0=1e-2/10e-4;
lda0=800e-9;
k=2*pi/lda0;


phis=linspace(0,2*pi,N);
zs=0;
rhos=linspace(0,20e-6,N);



er=@(phi) cos((l-1)*phi);
ep=@(phi) -sin((l-1)*phi);

Ex=@(theta,phi) (er(phi) -1i*sigma*ep(phi)) .* (-cos(theta).*cos(phi)) + ...
    (ep(phi) + 1i*sigma*er(phi)) .* (-sin(phi));


Ey=@(theta,phi) (er(phi) -1i*sigma*ep(phi)) .* (-cos(theta).*sin(phi)) + ...
    (ep(phi) + 1i*sigma*er(phi)) .* (cos(phi));

Ez=@(theta,phi) (er(phi) -1i*sigma*ep(phi)) .* (sin(theta))     + ...
    (ep(phi) + 1i*sigma*er(phi)) .* (0);



w0=@(theta) (sqrt(2)*beta0*sin(theta)/sin(alpha)).^abs(l) .*exp(-(beta0*sin(theta)/sin(alpha)).^2);



integrandx= @(theta,phi, rhos,phis) w0(theta).* exp(1i*k*(zs.*cos(theta)+rhos.*sin(theta).*cos(phi-phis))).* Ex(theta,phi) .*sin(theta).*sqrt(cos(theta)) ;
integrandy= @(theta,phi, rhos,phis) w0(theta).* exp(1i*k*(zs.*cos(theta)+rhos.*sin(theta).*cos(phi-phis))).* Ey(theta,phi) .*sin(theta).*sqrt(cos(theta)) ;
integrandz= @(theta,phi, rhos,phis) w0(theta).* exp(1i*k*(zs.*cos(theta)+rhos.*sin(theta).*cos(phi-phis))).* Ez(theta,phi) .*sin(theta).*sqrt(cos(theta)) ;

theta=linspace(0,alpha,N);
phi=linspace(0,2*pi,N);

[THETA, PHI]=meshgrid(theta, phi);
[RHOS, PHIS]=meshgrid(rhos, phis);


if p==0
    for i=1:length(rhos)
        for j=1:length(phis)
            esx(j,i)=sum(sum(integrandx(THETA,PHI, rhos(i),phis(j))));
            esy(j,i)=sum(sum(integrandy(THETA,PHI, rhos(i),phis(j))));
            esz(j,i)=sum(sum(integrandz(THETA,PHI, rhos(i),phis(j))));
    
        end
    end
else
    Lval=L(abs(l),p, 2*(beta0*sin(THETA)/sin(alpha)).^2);
    for i=1:length(rhos)
        for j=1:length(phis)
            esx(j,i)=sum(sum(Lval.*integrandx(THETA,PHI, rhos(i),phis(j))));
            esy(j,i)=sum(sum(Lval.*integrandy(THETA,PHI, rhos(i),phis(j))));
            esz(j,i)=sum(sum(Lval.*integrandz(THETA,PHI, rhos(i),phis(j))));
    
        end
    end
end

% s=size(RHOS);
% rq=reshape(RHOS, [s(1)*s(2),1]);
% pq=reshape(PHIS, [s(1)*s(2),1]);

X=RHOS.*cos(PHIS);
Y=RHOS.*sin(PHIS);

normE=sqrt(abs(esx).^2 + abs(esy).^2 + abs(esz).^2);

% surf(X,Y,abs(esx).^2 + abs(esy).^2 + abs(esz).^2, 'LineStyle','None');
% view(0,90)


%% Plot
fig=figure();
fig.Name=['l=', num2str(l), ' p=', num2str(p) ', sigma=', num2str(sigma)];
subplot(1,4,1)
surf(X,Y, abs(esx), 'LineStyle','None')
view(0,90)
title('E_x')
xlabel('x'); ylabel('y')
colorbar()

subplot(1,4,2)
surf(X,Y, abs(esy), 'LineStyle','None')
view(0,90)
title('E_y')
xlabel('x'); ylabel('y')
colorbar()

subplot(1,4,3)
surf(X,Y, abs(esz), 'LineStyle','None')
view(0,90)
title('E_z')
xlabel('x'); ylabel('y')
colorbar()

subplot(1,4,4)
surf(X,Y, normE, 'LineStyle','None')
view(0,90)
title('normE')
xlabel('x'); ylabel('y')
colorbar()

colormap jet
set(gcf, 'position', [6         448        1355         214])

%% Save
exportgraphics(fig, [savePath, fig.Name, '.png'], 'Resolution',150)