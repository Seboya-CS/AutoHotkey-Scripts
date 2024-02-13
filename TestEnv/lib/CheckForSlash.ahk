#Requires AutoHotkey v2.0

CheckForSlash(path)
{
	strL := StrLen(path)
	lastChar := SubStr(path, strL, 1)
	if (lastChar = "\") {
		return(path)
	} else {
		return(path . "\")
	}
}