#SingleInstance force
vers := A_AhkVersion
testVer := "1.0.39.00"

vers2 := StrReplace(vers, ".")
testVer2 := StrReplace(testVer, ".")

versNum := Number(vers2)
testVerNum := Number(testVer2)

!D::
{
msgbox(versNum)
msgbox(testVerNum)
}