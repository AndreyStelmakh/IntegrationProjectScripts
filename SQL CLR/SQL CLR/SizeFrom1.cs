using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;

public partial class UserDefinedFunctions
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString SizeFrom1(SqlString value)
    {
        // приоритет: One size, XL-style, числовой
        if (PatternOneSize.IsMatch(value.Value))
            return OneSize;

        if (PatternXXXL.IsMatch(value.Value)) return XXXL;
        if (PatternXXL.IsMatch(value.Value)) return XXL;
        if (PatternXL.IsMatch(value.Value)) return XL;
        if (PatternL.IsMatch(value.Value)) return L;
        if (PatternM.IsMatch(value.Value)) return M;
        if (PatternS.IsMatch(value.Value)) return S;
        if (PatternXS.IsMatch(value.Value)) return XS;

        var numericMatch = PatternNumeric.Match(value.Value);

        if(numericMatch.Success)
        {
            return new SqlString(numericMatch.Value);
        }

        return new SqlString (string.Empty);
    }

    static UserDefinedFunctions()
    {
        PatternOneSize = new Regex("One s", RegexOptions.IgnoreCase);

        // XS S M L XL XXL XXXL
        PatternXXXL = new Regex("XXXL", RegexOptions.IgnoreCase);
        PatternXXL = new Regex("XXL", RegexOptions.IgnoreCase);
        PatternXL = new Regex("XL", RegexOptions.IgnoreCase);
        PatternL = new Regex("L", RegexOptions.IgnoreCase);
        PatternM = new Regex("M", RegexOptions.IgnoreCase);
        PatternS = new Regex("S", RegexOptions.IgnoreCase);
        PatternXS = new Regex("XS", RegexOptions.IgnoreCase);

        PatternNumeric = new Regex("\\d+");
    }

    static readonly Regex PatternXXXL;
    static readonly Regex PatternXXL;
    static readonly Regex PatternXL;
    static readonly Regex PatternL;
    static readonly Regex PatternM;
    static readonly Regex PatternS;
    static readonly Regex PatternXS;
    static readonly Regex PatternOneSize;
    static readonly Regex PatternNumeric;

    const string OneSize = "One size";
    const string XXXL = "XXXL";
    const string XXL = "XXL";
    const string XL = "XL";
    const string L = "L";
    const string M = "M";
    const string S = "S";
    const string XS = "XS";
}
