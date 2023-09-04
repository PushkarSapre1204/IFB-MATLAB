syms y(x) y0 
Dy = diff(y);
D2y = diff(y,2);
ode = D2y + 2*Dy + y == 0;
ySol(x,y0) = dsolve(ode,[Dy(0)==0,y(-1)==0,y(0)==y0])

%%
figure;
fsurf(ySol,[0 1  -1 1])
xlabel('x')
ylabel('y_0 (Initial Condition)')

%% 
syms c b k m x(t); % c is damping, b is inertance, k is stiffness
%x_dot = diff(x);
%x_double_dot = diff(x_dot);
F = m*diff(x,2) + c*diff(x) + k*x == 0;

%F = m*diff(diff(x)) == 0;

Amp = dsolve(F)
pretty_equation(Amp)
%%
syms x(t) m k

F = m*diff(x,t,2) == -k*x;
Dx = diff(x,t)

cond = [x(0) == 0, Dx(0) == 0];
Amp_sym = dsolve(F)

Amp_num = subs(Amp_sym, [sym('m'), sym('k') sym('C1'), sym('C2')], [10, 5, 1, 1] )

fplot(Amp_num)
xlim([0, 100])
ylim([-3, 3])

%% Coupled differential equations
syms x(t) m r k F0(t) omega(t) omega_ramp_slope m_unb

F = m*diff(x, t, 2) + k*x == F0*sin(omega*t);
spin_profile = diff(omega, t) == omega_ramp_slope;
F_unb = diff(F0, t) == m_unb*diff(omega^2, t)*r;

cond = omega(0) == 0;
eqns = [F, spin_profile, F_unb];

sym_out = dsolve(eqns,cond);