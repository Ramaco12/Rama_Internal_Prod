enum 80125 "Mandate Invoice Type"
{
    Extensible = true;

    value(0; Blank)
    {
        Caption = ' ';
    }
    value(1; Percentage)
    {
        Caption = 'Percentage';
    }
    value(2; Lumpsum)
    {
        Caption = 'Lumpsum';
    }
}