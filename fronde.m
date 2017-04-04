% Robust estimation of median and variance of data
% @author : celine.meillier@unistra.fr, raphael.bacher@gipsa-lab.fr
%     Parameters
%     ----------
%     x : array-like.
%     niter : int
%         Max number of iterations.
%     fact_value: float (between 0 and 1)
%         Factor of truncation (for improved robustness.)
%     sym: bool
%         If True compute sigma using interquartile Q3-Q1 else use median-Q1
%
%     Returns
%     -------
%     medclip : scalar
%         Robust median estimate
%     sigclip2 : scalar
%         Robust standard deviation estimate

function [medclip,stdclip] = fronde(x, niter, fact_value ,sym)
    switch nargin
        case 3
            sym = true ;
        case 2
            sym = true ;
            fact_value = 0.9 ; 
        case 1 
            sym = True ;
            fact_value = 0.9 ; 
            niter  = 20 ;
    end
    
    x_sorted = sort(x(:)) ;
    fact_IQR = norminv(0.75,0,1) - norminv(0.25,0,1) ;
    xclip = x_sorted ;
    
    % Initialize
    facttrunc = norminv(fact_value,0,1) ;
    cdf_facttrunc = cdf('Normal', facttrunc, 0,1) ;
    correction = norminv((0.75*( 2*cdf_facttrunc-1 ) + (1 - cdf_facttrunc) ), 0,1) - norminv(0.25*( 2*cdf_facttrunc-1 ) + (1 - cdf_facttrunc), 0,1) ;
    medclip = middle(xclip) ;
    qlclip = percent(xclip, 25) ;
    stdclip = 2.*(medclip - qlclip)/fact_IQR ; 
    oldmedclip=1. ;
    oldstdclip=1. ;
    
    i=0 ;
    
    % Loop
    while ( (oldmedclip ~= medclip) && (oldstdclip ~=  stdclip) && (i < niter) )
        xclip = x_sorted(x_sorted >= medclip-facttrunc*stdclip & x_sorted <= medclip+facttrunc*stdclip ) ;
        oldoldmedclip=oldmedclip ;
        oldmedclip = medclip ;
        oldoldstdclip=oldstdclip ;
        oldstdclip=stdclip ;
        medclip = middle(xclip);
        qlclip = percent(xclip, 25) ;
        qlclip2 = percent(xclip, 75) ;
        if sym==true
            stdclip = abs(qlclip2 - qlclip)/correction ;
        else
            stdclip = 2*abs(medclip - qlclip)/correction ;
        end
        
       
        if oldoldmedclip ==medclip %gestion des cycles
            if stdclip>oldstdclip
                break
            else
                stdclip=oldstdclip ;
                medclip=oldmedclip ; 
            end
        end 
        i= i +1 ;
        
    end
    
    
    
    function middle_value = middle(L)
%         Get median assuming L is sorted
%         L: array 
        n = length(L(:)) ;
        m = n-1 ;
        middle_value = (L(int32(n/2)) + L(int32(m/2)) )/2.0 ;
    end

    function percentile_value = percent(L, q)
%         Computes the q-percentile value of array L.
%         L: array
%         q: float betwwen 0-100
    
        n0 = q/100. *length(L(:)) ; 
        n = int32(floor(n0)) ; 
        if n >= length(L(:))
            percentile_value = L(length(L(:))) ; 
        end
        if n >= 1
            if n == n0
                percentile_value = L(n-1);
            else
                percentile_value = (L(n-1) + L(n))/2.0 ;
            end
        else
            percentile_value = L(1) ; 
        end
    end 
end
