clc; close all; clear;
%% Using p=0
l=1;
sigma=1;
alpha=30 *(pi/180);
beta0=1e-2/10e-6;
lda0=800e-9;
k=2*pi/lda0;

phis=linspace(0,2*pi,100);
zs=0;
rhos=linspace(0,1e-6,100);
rhos=reshape(rhos, [1,1,length(rhos)]);


er=@(phi) cos((l-1)*phi);
ep=@(phi) -sin((l-1)*phi);

E=@(theta,phi) (er(phi) -1i*sigma*ep(phi)) .* [-cos(theta).*cos(phi);  -cos(theta).*sin(phi); sin(theta)] + ...
    (ep(phi) + 1i*sigma*er(phi)) .* [-sin(phi);  cos(phi); 0]



w0=@(theta) (sqrt(2)*beta0*sin(theta)/sin(alpha)).^abs(l) .*exp(-(beta0*sin(theta)/sin(alpha)).^2);


integrand= @(theta) w0(theta).* exp(1i*k*(zs.*cos(theta)+rhos.*sin(theta).*cos(phi-phis))).* E(theta,phi) .*sin(theta).*sqrt(cos(thetea)) ;

theta=linspace(0,alpha,100);
phi=linspace(0,2*pi,100);




