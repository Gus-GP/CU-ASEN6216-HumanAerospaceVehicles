% --------------------------------------------------------------------
% CU Boulder - ASEN 6216 Fall 2022
% NSEEV Project - Group 1
% Computational simulation of human display monitoring
% --------------------------------------------------------------------

% N -> Noticing
% S -> Salience
% Ef -> Effort
% Ex -> Expectancy
% V -> Value
% A -> Area Of Interest (AOI)
% Pabs(A) - absolute probability of viewing a "next"

%% House Keeping
clc;
clear;

%% Constants
%Display A
S_a = 2;
Ex_a = 4;
V_a = 2;
%Display B
S_b = 3;
Ex_b = 2;
V_b = 1;
%Display C
S_c = 1;
Ex_c = 3;
V_c = 1;
%Display D
S_d = 2;
Ex_d = 1;
V_d = 5;

%Effort values (Ef_ab = Ef_ba)
Ef_ab = 1;
Ef_ac = 1;
Ef_ad = 5;
Ef_bc = 3;
Ef_bd = 6;
Ef_cd = 4.5;

%Absolute probabilities
%monitoring to a
Pabs_btoa = S_a - Ef_ab + Ex_a + V_a;
Pabs_ctoa = S_a - Ef_ac + Ex_a + V_a;
Pabs_dtoa = S_a - Ef_ad + Ex_a + V_a;
%monitoring to b
Pabs_atob = S_b - Ef_ab + Ex_b + V_b;
Pabs_ctob = S_b - Ef_bc + Ex_b + V_b;
Pabs_dtob = S_b - Ef_bd + Ex_b + V_b;
%monitoring to c
Pabs_atoc = S_c - Ef_ac + Ex_c + V_c;
Pabs_btoc = S_c - Ef_bc + Ex_c + V_c;
Pabs_dtoc = S_c - Ef_cd + Ex_c + V_c;
%monitoring to d
Pabs_atod = S_d - Ef_ad + Ex_d + V_d;
Pabs_btod = S_d - Ef_bd + Ex_d + V_d;
Pabs_ctod = S_d - Ef_cd + Ex_d + V_d;

%Relative probabilities
%monitoring from a
Prel_atob = (Pabs_atob) / (Pabs_atob + Pabs_atoc + Pabs_atod);
Prel_atoc = (Pabs_atoc) / (Pabs_atob + Pabs_atoc + Pabs_atod);
Prel_atod = (Pabs_atod) / (Pabs_atob + Pabs_atoc + Pabs_atod);
%monitoring from b
Prel_btoa = (Pabs_btoa) / (Pabs_btoa + Pabs_btoc + Pabs_btod);
Prel_btoc = (Pabs_btoc) / (Pabs_btoa + Pabs_btoc + Pabs_btod);
Prel_btod = (Pabs_btod) / (Pabs_btoa + Pabs_btoc + Pabs_btod);
%monitoring from c
Prel_ctoa = (Pabs_ctoa) / (Pabs_ctoa + Pabs_ctob + Pabs_ctod);
Prel_ctob = (Pabs_ctob) / (Pabs_ctoa + Pabs_ctob + Pabs_ctod);
Prel_ctod = (Pabs_ctod) / (Pabs_ctoa + Pabs_ctob + Pabs_ctod);
%monitoring from d
Prel_dtoa = (Pabs_dtoa) / (Pabs_dtoa + Pabs_dtob + Pabs_dtoc);
Prel_dtob = (Pabs_dtob) / (Pabs_dtoa + Pabs_dtob + Pabs_dtoc);
Prel_dtoc = (Pabs_dtoc) / (Pabs_dtoa + Pabs_dtob + Pabs_dtoc);

%% Variables
%Create log normal distribution object for fixation time
fixation_pd = makedist('Lognormal','mu',0,'sigma',0.5); %seconds
%Create normal distribution object for duration of eye movement
saccadic_pd = makedist('Normal','mu',0.03,'sigma',0.003); %seconds
%% Simulaiton logic
fixations = 10;
display = string(zeros(1,fixations));
fixation = zeros(1,fixations);
saccadic = zeros(1,fixations);
tot_time = zeros(1,fixations);
disp_temp = 'A';
%initial values
display(1) = disp_temp;
%start at A - decide where to go next
for i = 2:fixations
    %generate a random number between 0 and 1
    X = rand;
    %select which display to see next - %REVIEW logic
    if disp_temp == 'A'
        if X < Prel_atob
            disp_temp = 'B';
        elseif X < Prel_atob + Prel_atoc
            disp_temp = 'C';
        else
            disp_temp = 'D';
        end
    elseif disp_temp == 'B'
        if X < Prel_btoa
            disp_temp = 'A';
        elseif X < Prel_btoa + Prel_btoc
            disp_temp = 'C';
        else
            disp_temp = 'D';
        end
    elseif disp_temp == 'C'
        if X < Prel_ctoa
            disp_temp = 'A';
        elseif X < Prel_ctoa + Prel_ctod
            disp_temp = 'D';
        else
            disp_temp = 'B';
        end
    elseif disp_temp == 'D'
        if X < Prel_dtoa
            disp_temp = 'A';
        else
            disp_temp = 'C';
        end
    end
    %push value into disp array
    display(i) = disp_temp;
    %generate a random number for fixation
    fix_val = random(fixation_pd);
    %push into array
    fixation(i) = fix_val;
    %generate a random number for saccadian eye movement
    eye_val = random(saccadic_pd);
    tot_time(i) = tot_time(i-1) + fix_val + eye_val;
    %push into array
    saccadic(i) = eye_val;
end

%% Graphing results
y=categorical(display);
x=tot_time;
plot(x,y,'ko-')
xlabel('Total time (Seconds)','FontSize',15)
ylabel('Display','FontSize',15)
title('Computational simulation of Human Display Monitoring')

