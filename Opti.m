% �ڕW�g���N
desiredTorque = 5.0;

% �ڕW�d��
Ia = ( ( 2 * desiredTorque ) / ( Pn * Phia ) );

% id, iq�̕`��͈�
idRange = ( -100:1:100 )';
iqRange = ( -100:1:100 )';

%% 2D�`��i�ő�g���N����j
figure(1); hold on;

% �p�x ( 0 -> 2 * pi )
th = linspace( 0, 2 * pi, 100 )';

xConst = Ia * cos( th );
yConst = Ia * sin( th );
plot( xConst, yConst, 'Color', [0.0,1.0,0.0] );

% �ڕW�g���N�f�ʂł̃g���N�Ȑ�
TorqueRange = linspace( 0.5, 10, 20 )';
for cnt = 1:length( TorqueRange )
    iqout = iqFunc( idRange, TorqueRange(cnt), Pn, Phia, Ld, Lq );
    plot( idRange, iqout, 'Color', [0.5,0.5,0.5] ); hold on;
end

% �œK�d���ʑ�
beta = asin( ( -Phia + sqrt( Phia^2 + 8 * ( Ld - Lq )^2 * Ia^2 ) ) / ( 4 * ( Lq - Ld ) * Ia ) );

% �ő�g���N�x�N�g���̕`��
var = [ -Ia * sin( beta );Ia * cos( beta ) ]; % d���d���Cq���d��
scatter( var(1), var(2), 'MarkerFaceColor', [0,1,0], 'MarkerEdgeColor', 'None' );
sqrt( var(1)^2 + var(2)^2 )

% �ڕW�g���N�f�ʂł̃g���N�Ȑ�(id=0)
iqout = iqFunc( idRange, desiredTorque, Pn, Phia, Ld, Lq );
plot( idRange, iqout, 'Color', [0,0,1] );

% buff = (Pn/2) * ( Phia * var(2) + ( Lq - Ld ) * var(1) * var(2) );
MaxTorque = ( Pn / 2 ) * Phia * Ia * cos( beta ) + ( Pn / 2 ) * ( Lq - Ld ) * Ia^2 * sin( 2 * beta ) / 2;

iqout = iqFunc( idRange, MaxTorque, Pn, Phia, Ld, Lq );
plot( idRange, iqout, 'Color', [0.0,0.0,1.0] ); hold on;

% �œK�x�N�g���̕`��
r = 0:1:100;
th = atan2( var(2), var(1) );
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [0,1,0] );

% id=0�x�N�g���̕`��
r = 0:1:100;
th = pi / 2;
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [1,0,0] );
scatter( 0, ( ( 2 * desiredTorque ) / ( Pn * Phia ) ), 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' );
sqrt( 0^2 + ( ( 2 * desiredTorque ) / ( Pn * Phia ) )^2 )

axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );
axis equal;

%% 2D�`��i�ő��������j
figure(2); hold on;

% �p�x ( 0 -> 2 * pi )
th = linspace( 0, 2 * pi, 50 )';

% ���S�~�̊Ԋu
rRange = ( 0:5:100 )';

% �d���̓��S�~
for cnt = 1:length( rRange )
    xConst = rRange(cnt) * cos( th );
    yConst = rRange(cnt) * sin( th );
    plot( xConst, yConst, 'Color', [0.5,0.5,0.5] );
end

% �ڕW�g���N�f�ʂł̃g���N�Ȑ�
iqout = iqFunc( idRange, desiredTorque, Pn, Phia, Ld, Lq );
plot( idRange, iqout, 'Color', [0,0,1] );

% �j���[�g���@�ł̍ō������쓮
% �����l [ id, iq, lmd ]
var = [ 0;( ( 2 * desiredTorque ) / ( Pn * Phia ) );0; ];

for cnt = 1:3
    var = var - HessianMatrix( desiredTorque, var(1), var(2), var(3), Pn, Ld, Lq, Phia) \ GradVector( desiredTorque, var(1), var(2), var(3), Pn, Ld, Lq, Phia);
end

scatter( var(1), var(2), 'MarkerFaceColor', [0,1,0], 'MarkerEdgeColor', 'None' );
sqrt( var(1)^2 + var(2)^2 )

% �ډ~�̕`��
r = sqrt( var(1)^2 + var(2)^2 );
th = linspace( 0, 2 * pi, 100 )';
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [0,1,0] );

% �œK�x�N�g���̕`��
r = 0:1:100;
th = atan2( var(2), var(1) );
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [0,1,0] );

% id=0�x�N�g���̕`��
r = 0:1:100;
th = pi / 2;
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [1,0,0] );
scatter( 0, ( ( 2 * desiredTorque ) / ( Pn * Phia ) ), 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' );
sqrt( 0^2 + ( ( 2 * desiredTorque ) / ( Pn * Phia ) )^2 )

axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );
axis equal;

%% 3D�`��
figure(3); hold on;

% �g���N�}�b�v�̕`��
[ Id, Iq ] = meshgrid( idRange, iqRange );
T = Tfunc( Id, Iq, Pn, Phia, Ld, Lq );
surf( Id, Iq, T, 'LineStyle', 'none' ); hold on;

% ���S�~�̊Ԋu
rRange = ( 0:5:100 )';
% �p�x ( 0 -> 2 * pi )
th = linspace( 0, 2 * pi, 50 )';

% �d���̓��S�~
for cnt = 1:length( rRange )
    xConst = rRange(cnt) * cos( th );
    yConst = rRange(cnt) * sin( th );
    plot3( xConst, yConst, desiredTorque * ones( size( th ) ), 'Color', [0.5,0.5,0.5] );
end


% �j���[�g���@�ł̍ő��������
% ����_
% �����l [ id, iq, lmd ]
var = [ 0;0;0; ];
for cnt = 1:10
    var = var - HessianMatrix( desiredTorque, var(1), var(2), var(3), Pn, Ld, Lq, Phia) \ GradVector( desiredTorque, var(1), var(2), var(3), Pn, Ld, Lq, Phia);
end
scatter3( var(1), var(2), desiredTorque, 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' );

% �ډ~
r = sqrt( var(1)^2 + var(2)^2 );
th = linspace( 0, 2 * pi, 100 )';
x = r * cos( th );
y = r * sin( th );
plot3( x, y, desiredTorque * ones( size( x ) ), 'Color', [1,0,0] );

% �ډ~���S���瓮��_�܂ł̐�
r = 0:1:100;
th = atan2( var(2), var(1) );
x = r * cos( th );
y = r * sin( th );
plot3( x, y, desiredTorque * ones( size( x ) ),'Color', [1,0,0] );

% �ڕW�g���N�f�ʂł̃g���N�Ȑ�
iqout = iqFunc( idRange, desiredTorque, Pn, Phia, Ld, Lq );
plot3( idRange, iqout, desiredTorque * ones( size( idRange ) ), 'Color', [0,0,1] );


% �ő�g���N����
% ����_
scatter3( -Ia * sin( beta ), Ia * cos( beta ), MaxTorque, 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' )

% �ډ~
r = Ia;
th = linspace( 0, 2 * pi, 100 )';
x = r * cos( th );
y = r * sin( th );
plot3( x, y, MaxTorque * ones( size( x ) ), 'Color', [1,0,0] );

% �ډ~���S���瓮��_�܂ł̐�
r = 0:1:100;
x = -r * sin( beta );
y = r * cos( beta );
plot3( x, y, MaxTorque * ones( size( x ) ), 'Color', [1,0,0] );

% �ڕW�g���N�f�ʂł̃g���N�Ȑ�
iqout = iqFunc( idRange, MaxTorque, Pn, Phia, Ld, Lq );
plot3( idRange, iqout, MaxTorque * ones( size( idRange ) ), 'Color', [0,0,1] );


% id=0����
% ����_
scatter3( 0, Ia, desiredTorque, 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' )

% �ډ~�͏ȗ�

% �ډ~���S���瓮��_�܂ł̐�
r = 0:1:100;
th = pi / 2;
x = r * cos( th );
y = r * sin( th );
plot3( x, y, desiredTorque * ones( size( x ) ), 'Color', [1,0,0] );

% �ڕW�g���N�f�ʂł̃g���N�Ȑ��͏ȗ�

% ���̐ݒ�
axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );

%% ���x��
figure(1);
xlabel('Current of d-axis i_d');
ylabel('Current of q-axis i_q');
axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );

figure(2);
xlabel('Current of d-axis i_d');
ylabel('Current of q-axis i_q');
axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );

figure(3);
xlabel('Current of d-axis i_d');
ylabel('Current of q-axis i_q');
zlabel('Torque T');
axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );

