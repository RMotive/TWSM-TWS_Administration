﻿using Foundation.Contracts.Exceptions.Interfaces;

namespace Foundation;

public class GenericExceptionExposure
    : IGenericExceptionExposure {
    public string Message { get; set; } = string.Empty;
    public Dictionary<string, dynamic> Failure { get; set; } = [];
}
