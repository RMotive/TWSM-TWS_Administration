﻿using System.Net;

using CSMFoundation.Server.Bases;

namespace CSMFoundation.Server.Exceptions;
public class XDisposition
    : BServerTransactionException<XDispositionSituation> {
    public XDisposition(XDispositionSituation Situation)
        : base($"Wrong disposition configuration", HttpStatusCode.BadRequest, null) {

        this.Situation = Situation;
        this.Advise = Situation switch {
            XDispositionSituation.Value => "Wrong CSMDisposition header acceptance value",
            _ => throw new ArgumentException(null, nameof(Situation)),
        };
    }
}

public enum XDispositionSituation {
    Value,
}
