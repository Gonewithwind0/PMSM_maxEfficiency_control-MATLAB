function [ torque, Ia ] = generateTorqueMap( IaMin, IaMax, div, Pn, Phia, Ld, Lq )
    % �}�b�v������d���͈�
    Ia = linspace( IaMin, IaMax, div )';
    
    % �[�������
    Ia( abs( Ia ) < eps ) = eps;
    
    % �œK�d���ʑ�
    beta = asin( ( -Phia + sqrt( Phia.^2 + 8 * ( Ld - Lq ).^2 .* Ia.^2 ) ) ./ ( 4 * ( Lq - Ld ) .* Ia ) );

    % Ia���Ƃ̍ő�g���N
    torque = ( Pn / 2 ) * Phia .* Ia .* cos( beta ) + ( Pn / 2 ) * ( Lq - Ld ) * Ia.^2 .* sin( 2 * beta ) ./ 2;
end