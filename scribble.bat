for /f %%f in ('dir /b /d .\fonts') do (
	for /f %%n in ('dir /b .\fonts\%%f\*.yy') do (
		copy .\fonts\%%f\%%n .\datafiles\data\fonts\%%n
	)
)