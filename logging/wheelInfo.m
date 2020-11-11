close all;
load l_wheel_speed.log;
load l_wheel_torque.log;
load l_wheel_voltage.log;
load l_wheel_rotation.log;
load l_wheel_velocity.log;
load l_wheel_pulses.log;
load simulated_time.log;
omega = l_wheel_speed;
torque = l_wheel_torque;
voltage = l_wheel_voltage;
rotation = l_wheel_rotation;
velocity = l_wheel_velocity;
pulses = l_wheel_pulses;


firstIndex = find(abs(torque)>1e-6);
firstIndex = firstIndex(1);
indexes = firstIndex:length(simulated_time);

time = simulated_time(indexes)-simulated_time(firstIndex);
omega = omega(indexes);
torque = torque(indexes);
voltage = voltage(indexes);
rotation = rotation(indexes);
velocity = velocity(indexes);
pulses = pulses(indexes);

figure;
yyaxis left;
plot(time,omega,'-');hold on;
ylabel('Velocidade angular da roda (rad/s)');
yyaxis right;
plot(time,torque,'-');hold off;
ylabel('Torque aplicado na roda (rad/s)');
xlabel('tempo (s)');
