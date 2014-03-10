    @echo off
    setLocal EnableDelayedExpansion
    GOTO checkvars
    
    :checkvars
    	IF "%1"=="" GOTO syntaxerror
    	IF NOT "%1"=="-f"  GOTO syntaxerror
    	IF %2=="" GOTO syntaxerror
    	IF NOT EXIST %2 GOTO nofile
    	IF "%3"=="" GOTO syntaxerror
    	IF NOT "%3"=="-n" GOTO syntaxerror
    	IF "%4"==""  GOTO syntaxerror
    	set param=%4
    	echo %param%| findstr /xr "[1-9][0-9]* 0" >nul && (
    		goto proceed
    	) || (
    		echo %param% is NOT a valid number
    		goto syntaxerror
    	)
    
    :proceed
    	set limit=%4
    	set file=%2
    	set lineCounter=1+%limit%
    	set filenameCounter=0
    
    	set name=
    	set extension=
    
    	for %%a in (%file%) do (
    		set "name=%%~na"
    		set "extension=%%~xa"
    	)
    
    	for /f "usebackq tokens=*" %%a in (%file%) do (
    		if !lineCounter! gtr !limit! (
				set splitFile=!name!_part!filenameCounter!!extension!
				set /a filenameCounter=!filenameCounter! + 1
    			set lineCounter=1
    			echo Created !splitFile!.
			)
			cls
			echo Adding Line !splitFile! - !lineCounter!
			echo %%a>> !splitFile!
			set /a lineCounter=!lineCounter! + 1
    	)
    	echo Done!
    	goto end
    :syntaxerror
    	Echo Syntax: %0 -f Filname -s NumberOfRowsPerFile
    	goto end
    :nofile
    	echo %2 does not exist
    	goto end
    :end
