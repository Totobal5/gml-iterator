#macro GML_ITERATOR_CREDITS	"GML Iterator - creado por toto "
#macro GML_ITERATOR_VERSION	"\nversion: 1.0.0"	

show_debug_message(GML_ITERATOR_CREDITS + GML_ITERATOR_VERSION);


globalvar __trstack, __trtop, __trold;

__trstack = ds_stack_create();
__trtop = -1;
__trold = -2;

/**
	@param {Mixed} data
	@param type
	@param [ds_type]
*/
function __TypeReader(_name, _type, _ds = undefined) {
	if (__trtop == __trold) return (__trtop.__reset() );
	
	var _push = {
		__in: undefined,
		
		__name : "",
		__kname: "",
		__iname: "",
		
		__pos: -1,
		__len: -1,
		
		__reset: function() {__pos = -1; return (__set() ); },
		__set:	 function() {return self; }
	}
	
	if (is_array(_type) ) {
		with (_push) {
			__in = _type;
			__name  = (is_array(_name) ) ? _name[0] : _name;
			__iname = (is_array(_name) ) ? _name[1] :   "i";
			
			__len = array_length(__in) - 1;
			__set = function() {
				__pos++;
				
				variable_struct_set(self, __name ,	__in[__pos] );
				variable_struct_set(self, __iname,	__pos ); 

				return self;
			}
		}
	}
	else if (is_struct(_type) ) {
		with (_push) {
			__in = _type;
			__name  = (is_array(_name) ) ? _name[0] : _name;
			__kname = (is_array(_name) ) ? _name[1] : "key";
			__iname = (is_array(_name) ) ? _name[2] :   "i";
			
			__keys = variable_struct_get_names(__in);
			__len  = array_length(__keys) - 1;
			
			__set = function() {
				__pos++;
				var _key = __keys[__pos];
				variable_struct_set(self, __name ,	__in[$ _key] );
				
				variable_struct_set(self, __kname,	_key ); 
				variable_struct_set(self, __iname,	__pos);
				
				return self;
			}
		}
	}
	else if (is_string(_type) ) {
		with (_push) {
			__in = _type;
			__name  = (is_array(_name) ) ? _name[0] : _name;
			__iname = (is_array(_name) ) ? _name[1] :   "i";
			__rname = (is_array(_name) ) ? _name[2] : "pos";	// Posicion empezando desde 0
			
			__len = string_length(__in) - 1;
			__pos = 0;	// String empiezan de 1 (osea poner en 0)
			
			__set = function() {
				__pos++;
				
				variable_struct_set(self, __name ,	string_char_at(__in, __pos) );
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
		switch (_ds) {
			#region DS List
			case ds_type_list:
				with (_push) {
					__in = _type;
					__name  = (is_array(_name) ) ? _name[0] : _name;
					__iname = (is_array(_name) ) ? _name[1] :   "i";
			
					__len = ds_list_size(__in);
					__set = function() {
						__pos++;
				
						variable_struct_set(self, __name ,	__in[| __pos] );
						variable_struct_set(self, __iname,	__pos ); 

						return self;
					}
				}
				break;
			#endregion
			
			#region DS Map
			case ds_type_map:
				with (_push) {
					__in = _type;
					__name  = (is_array(_name) ) ? _name[0] : _name;
					__kname = (is_array(_name) ) ? _name[1] : "key";
					__iname = (is_array(_name) ) ? _name[2] :   "i";
			
					__keys = ds_map_keys_to_array(__in);
					__len  = array_length(__keys);
					__pos  = -1;
					
					__set = function() {
						__pos++;
						var _key = __keys[__pos];
						
						variable_struct_set(self, __name ,	__in[? _key] );
				
						variable_struct_set(self, __kname,	 _key);
						variable_struct_set(self, __iname,	__pos);
	
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

#macro iter	with(__TypeReader(
#macro exc	)) {repeat(__len) {
#macro fin	__set();}} ds_stack_pop(__trstack);

/*
	TODO:
		* optimizar nomás.
		* quitar ese with?
*/