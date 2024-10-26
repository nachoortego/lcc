
function y = cos_n (x0 ,n )
// Entrada : x0 = valor real ; n = numero natural
// Salida : y = valor obtenido de aplicar reiteradamente la funcion cos (x) al punto x0
	y = x0
	for i =1: n
		y = cos(y)
	end
	disp(y)
endfunction

cos_n(5,20)
