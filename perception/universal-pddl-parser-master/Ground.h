
#ifndef _GROUND_H_
#define _GROUND_H_

#include "Lifted.h"

class Ground : public ParamCond {

public:

	Lifted * lifted;

	Ground()
		: ParamCond(), lifted( 0 ) {}

	Ground( const std::string s, const IntVec & p = IntVec() )
		: ParamCond( s, p ), lifted( 0 ) {}

	Ground( Lifted * l, const IntVec & p = IntVec() )
		: ParamCond( l->name, p ), lifted( l ) {}

	Ground( const Ground * g, Domain & d );

	void PDDLPrint( std::ostream & s, unsigned indent, const TokenStruct< std::string > & ts, Domain & d );

	void parse( Filereader & f, TokenStruct< std::string > & ts, Domain & d );

	void SHOPparse( Filereader & f, TokenStruct< std::string > & ts, Domain & d );

	void addParams( int m, unsigned n ) {
		for ( unsigned i = 0; i < params.size(); ++i )
			if ( params[i] >= m ) params[i] += n;
	}

	Condition * copy( Domain & d ) {
		return new Ground( this, d );
	}

};

typedef std::vector< Ground * > GroundVec;

#endif
