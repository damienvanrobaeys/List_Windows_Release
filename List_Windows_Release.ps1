$OS_List=@(Get-ChildItem -Path HKLM:\System\Setup\Source* | ForEach-Object {Get-ItemProperty -Path Registry::$_}; 
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion')
$Updates_Release = @()
ForEach($Release in $OS_List)
	{
		If($Release.DisplayVersion -ne $null)
			{
				$Release_Version = $Release.DisplayVersion
			}
		Else
			{
				$Release_Version = $Release.ReleaseID
			}	
		$Release_Build = $Release.CurrentBuild
		$Product_Name = $Release.ProductName		
		$Release_Date = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($Release.InstallDate))
		$Result = New-Object PSObject
		$Result = $Result | Add-Member NoteProperty "OS" $Product_Name -passthru -force				
		$Result = $Result | Add-Member NoteProperty "Release" $Release_Version -passthru -force
		$Result = $Result | Add-Member NoteProperty "Build" $Release_Build -passthru -force		
		$Result = $Result | Add-Member NoteProperty "Date" $Release_Date -passthru -force		
		$Updates_Release += $Result		
	}
$Updates_Release | Sort-Object Date