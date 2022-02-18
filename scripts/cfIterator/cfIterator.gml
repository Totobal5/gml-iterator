#macro GML_ITERATOR_CREDITS	"GML Iterator - creado por toto "
#macro GML_ITERATOR_VERSION	"\nversion: 1.0.0"	

show_debug_message(GML_ITERATOR_CREDITS + GML_ITERATOR_VERSION);


#macro START_TIMER	var time1, time2; time1 = get_timer();
#macro END_TIMER	time2 = get_timer(); show_debug_message("time: " + string( (time2 - time1) / 1000) + " [ms]");

globalvar __trstack, __trtop, __trold;

__trstack = ds_stack_create();
__trtop = -1;
__trold = -2;

/**
	@param {Mixed} data
	@param type
	@param [ds_type]
	, _ds = undefined
*/
function __TypeReader() {
	#region Definir struct
	if (__trtop == __trold) return (__trtop.__reset() );
	
	var _push = {
		data: undefined,				// Se puede acceder a la data si es que se necesita
		prev: ds_stack_top(__trstack),	// Obtener iteracion previa si es que se necesita
		
		__name : "",
		__kname: "",
		__iname: "",
		
		__pos: -1,
		__len: -1,
		
		__reset: function() {__pos = -1; return (__set() ); },
		__set:	 function() {return self; }
	}
	
	#endregion
	
	if (is_array(argument0) ) {
		with (_push) {
			data = argument0;
			__name  = argument1;
			__iname = argument2 ?? "i";
			
			// Soporte para in range (se usa el argumento 4)
			var _len = array_length(data);
			
			if (!is_undefined(argument3) ) {
				__len = clamp(argument3, 0, _len);	
			} else {
				__len = _len;	
			}
			
			__set = function() {
				__pos++;
				
				if (__pos > __len - 1) exit;
				
				variable_struct_set(self, __name ,	data[__pos] );
				variable_struct_set(self, __iname,	__pos ); 

				return self;
			}
		}
	}
	else if (is_struct(argument0) ) {
		with (_push) {
			data = argument0;
			__name  = argument1;
			__kname = argument2 ?? "key";
			__iname = argument3 ??   "i";
			
			__keys = variable_struct_get_names(data);
			__len  = array_length(__keys);
			
			__set = function() {
				__pos++
				
				if (__pos > __len - 1) exit;
				
				var _key = __keys[__pos];
				
				variable_struct_set(self, __name ,	data[$ _key] );
				
				variable_struct_set(self, __kname,	_key ); 
				variable_struct_set(self, __iname,	__pos);
				
				return self;
			}
		}
	}
	else if (is_string(argument0) ) {
		with (_push) {
			data = argument0;
			__name  = argument1
			__iname = argument2 ??   "i";
			__rname = argument3 ?? "pos";	// Posicion empezando desde 0
			
			__len = string_length(data);
			__pos = 0;	// String empiezan de 1 (osea poner en 0)
			
			__set = function() {
				__pos++;
				
				variable_struct_set(self, __name ,	string_char_at(data, __pos) );
				variable_struct_set(self, __iname,	__pos );
				variable_struct_set(self, __rname,	__pos - 1);

				return self;
			}
			
			__reset = function() {
				__pos = 0;
				return (__set() );
			}
		}
	}
	else {
		// Obtener el ultimo
		switch (argument[argument_count - 1] ) {
			#region DS List
			case ds_type_list:
				with (_push) {
					data = argument0;
					__name  = argument1;
					__iname = argument2 ?? "i";
			
					__len = ds_list_size(data);
					__set = function() {
						__pos++;
				
						variable_struct_set(self, __name ,	data[| __pos] );
						variable_struct_set(self, __iname,	__pos ); 

						return self;
					}
				}
				break;
			#endregion
			
			#region DS Map
			case ds_type_map:
				with (_push) {
					data = argument0;
					__name  = argument1;
					__kname = argument2 ?? "key";
					__iname = argument3 ??   "i";
			
					__keys = ds_map_keys_to_array(data);
					__len  = array_length(__keys);
					__pos  = -1;
					
					__set = function() {
						__pos++;
						var _key = __keys[__pos];
						
						variable_struct_set(self, __name ,	data[? _key] );
				
						variable_struct_set(self, __kname,	 _key);
						variable_struct_set(self, __iname,	__pos);
	
						return self;
					}
				}
				break;
			#endregion
			
			#region DS Grid
			case ds_type_grid:
				with (_push) {
					data = argument0;
					__name  = argument1;
					__iname = argument2 ?? "i";	// x grid
					__kname = argument3 ?? "j";	// y grid
			
					__real_len = [ds_grid_height(data), ds_grid_width(data) ];
					__len = __real_len[0] * __real_len[1];	// Obtener las veces necesarias para iterar
					
					__pos = [0, -1];
					
					__set = function() {
						// Reiniciar conteo
						if (__pos[1] < __real_len[1] ) {
							__pos[1]++;
						}
						else {
							__pos[0]++;
							__pos[1] = -1;
						}
						
						var _x = __pos[0], _y = __pos[1];
						
						variable_struct_set(self, __name ,	data[# _x, _y] );
						variable_struct_set(self, __iname,	_x); 
						variable_struct_set(self, __kname,  _y);
						

						return self;
					}
				}				
					
					
				break;
				
			#endregion
			
			default:	show_error("Iterator - Data type not supported", true);	break;
		}
	}
	// Push shiet
	__trold = __trtop;
	__trtop =   _push;
	
	ds_stack_push(__trstack, _push);
	
	return (__trtop.__set() );
}

#macro Iterate	with(__TypeReader(
#macro Work		)){repeat(__len) {
#macro End		__set();}} ds_stack_pop(__trstack);  



var _struct = {
	sex: array_create(100, 10),	
	exs: array_create(100, 10),
	omy: array_create(100, 10),
}

START_TIMER

repeat (1000) {
	Iterate _struct, "in", "variable", "index" Work
		if (is_array(in) ) {
			Iterate in, "in" Work	
				show_debug_message("array: " + string(in) );
			End
		}
	
		show_debug_message(variable + string(in) );
	End
}

END_TIMER


/*
	TODO:
		* optimizar nomás.
		* quitar ese with? X no se puede
*/