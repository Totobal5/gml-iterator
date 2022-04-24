#macro GML_ITERATOR_CREDITS	"-- GML Iterator - Creado por toto --"
#macro GML_ITERATOR_VERSION	"\n-- version: 1.1.0 --"	

show_debug_message(GML_ITERATOR_CREDITS + GML_ITERATOR_VERSION);

globalvar __trstack, __trtop, __trold;

__trstack = ds_stack_create();
__trtop = -1;
__trold = -2;

/// @param {Mixed} data
function __TypeReader() {
	#region Definir struct
	if (__trtop == __trold) return (__trtop.__reset() );
	
	var _push = {
		// Accesibles
		data: argument0,				// Se puede acceder a la data si es que se necesita
		inst: other,					// Obtener quien llama un iterator
		prev: ds_stack_top(__trstack),	// Obtener iteracion previa si es que se necesita
		
		__name : argument1 ?? "in",	/// @ignore
		
		__kname: "",	/// @ignore
		__iname: "",	/// @ignore
		
		__pos: -1,		/// @ignore
		__len: -1,		/// @ignore
		
		__reset: function() {__pos = -1; return (__set() ); },	/// @ignore
		//__set  : function() {return self; },					/// @ignore
		__inrange: function(_value, _min, _max) {
			return (!is_undefined(_value) ) ? clamp(_value, _min, _max) : _max; 	
		}
	}
	
	#endregion
	
	if (is_array(argument0) ) {
		#region Array
		with (_push) {
			__iname = argument2 ?? "i";
			
			// Soporte para in range (se usa el argumento 4)
			__len = __inrange(argument3, 1, array_length(data) );
			
			__set = function() {
				__pos++;

				variable_struct_set(self, __name ,	data[__pos] );
				variable_struct_set(self, __iname,	__pos ); 

				return self;
			}
		}
		#endregion
	}
	else if (is_struct(argument0) ) {
		#region Struct
		with (_push) {
			__kname = argument2 ?? "key";
			__iname = argument3 ??   "i";
			
			__keys = variable_struct_get_names(data);
			
			// Soporte para in range (se usa el argumento 5)
			__len = __inrange(argument4, 1, array_length(__keys) );

			__set = function() {
				var _key = __keys[++__pos];
				
				variable_struct_set(self, __name ,	data[$ _key] );
				
				variable_struct_set(self, __kname,	 _key); 
				variable_struct_set(self, __iname,	__pos);
				
				return self;
			}
		}
		
		#endregion
	}
	else if (is_string(argument0) ) {
		#region String
		with (_push) {
			__kname = argument2 ?? "char";	// Caracter en la posicion
			__iname = argument3 ??   "i";	// Posicion del string (desde 1 a __len)
			
			// Soporte para in range (se usa el argumento 5)
			__len = __inrange(argument4, 2, string_length(data) );
			__pos = 0;	// String empiezan de 1 (osea poner en 0)
			
			__set = function() {
				__pos++;
				
				variable_struct_set(self,  __name,  string_copy(data, 0, __pos) );	// Texto recreado
				variable_struct_set(self, __kname,	string_char_at(data, __pos) );	// Caracter
				variable_struct_set(self, __iname,	__pos );

				return self;
			}
			
			__reset = function() {
				__pos = 0;
				return (__set() );
			}
		}
		#endregion
	}
	else if (is_undefined(argument0) ) {
		#region Error
		with (_push) __len = 0;
		show_debug_message("Iterator: Undefined data!!");
		#endregion
	}
	else {
		#region DS DATA
		// Obtener el ultimo
		switch (argument1) {
			#region DS List
			case ds_type_list:
				with (_push) {
					__name  = argument2 ?? "in";
					__iname = argument3 ??  "i";
					__len = __inrange(argument4, 1, ds_list_size(data) );
					
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
					__kname = argument2 ?? "key";
					__iname = argument3 ??   "i";
			
					__keys = ds_map_keys_to_array(data);
					__len  = __inrange(argument4, 1, array_length(__keys) );
					
					__set = function() {
						var _key = __keys[++__pos];
						
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
					__iname = argument2 ?? "i";	// x grid
					__kname = argument3 ?? "j";	// y grid
			
					__real_len = [ds_grid_height(data), ds_grid_width(data) ];
					__len = __inrange(argument4, 1, __real_len[0] * __real_len[1] );
					
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
			
			default:	show_error("Iterator - Data type not supported", false);	break;
		}
		
		#endregion
	}
	// Push
	__trold = __trtop;
	__trtop =   _push;
	
	ds_stack_push(__trstack, _push);
	
	return (__trtop);
}

#macro iterate	with(__TypeReader
#macro istart	)repeat(__len) {__set();
#macro iend		} ds_stack_pop(__trstack);  

