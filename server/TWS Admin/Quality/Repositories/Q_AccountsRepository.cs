﻿using System.Text;
using Foundation.Managers;

using Microsoft.EntityFrameworkCore;

using TWS_Security.Entities;
using TWS_Security.Repositories;
using TWS_Security.Sets;
using Foundation.Enumerators.Records;

using Xunit;

using EntityReferenceResults = Foundation.Records.Datasources.OperationResults<TWS_Security.Entities.AccountEntity, TWS_Security.Entities.AccountEntity>;
using CriticalOperationResults = Foundation.Records.Datasources.CriticalOperationResults<TWS_Security.Entities.AccountEntity, TWS_Security.Sets.Account>;
using Foundation;
using Foundation.Exceptions.Datasources;
using Foundation.Contracts.Exceptions;
using Foundation.Records.Datasources;

namespace TWS_Security.Quality.Repositories;
public class Q_AccountsRepository {
    private readonly TWSSecuritySource Source;
    private readonly AccountsRepository Repo;
    private readonly AccountEntity[] Mocks = [];

    public Q_AccountsRepository() {
        Source = new TWSSecuritySource();
        Repo = new();

        for (int p = 0; p < 5; p++) {
            byte[] rp = Encoding.Unicode.GetBytes(RandomManager.String(8));
            string ru = RandomManager.String(7);

            AccountEntity re = new(ru, rp);
            Mocks = [.. Mocks, re];
        }
    }

    [Fact]
    public async void Create() {
        AccountEntity FirstFact = await Repo.Create(Mocks[0]);
        EntityReferenceResults SecondFact = await Repo.Create(Mocks[1], 3);
        EntityReferenceResults ThirdFact = await Repo.Create([Mocks[2], Mocks[3], Mocks[4], Mocks[2], Mocks[3]]);

        #region First Fact Asserts (Creating a single entity)
        Assert.Multiple((Action[])([
            () => Assert.True(FirstFact.Pointer > 0),
            () => Assert.ThrowsAsync<XUniqueViolation<Account>>(() => Repo.Create(Mocks[0])),
            () => {
                AccountEntity Entity = FirstFact;
                Account Set = Source.Accounts
                    .Where(i => i.Id == Entity.Pointer)
                    .FirstOrDefault()
                    ?? throw new Exception($"Item wasn't saved correctly {nameof(FirstFact)}");

                Assert.Equal(Entity.Pointer, Set.Id);
                Assert.Equal(Entity.User, Set.User);
                Assert.True(Entity.Password.SequenceEqual(Set.Password));

                Assert.True(Entity.EqualsSet(Set));

                Source.Remove(Set);
                Source.SaveChanges();
            },
        ]));
        #endregion  

        #region Second Fact Asserts (Creating copies of a Entity)
        Assert.Multiple([
            () => Assert.Single(SecondFact.Successes),
            () => Assert.Equal(2, SecondFact.Failures.Count),
            () => Assert.True(SecondFact.Successes[0].Pointer > 0),
            () => {
                Assert.All(SecondFact.Failures, 
                    (I) => {
                    Assert.Equal(OperationFailureCriterias.Entity, I.Criteria);
                });
            },
            () => {
                AccountEntity Entity = SecondFact.Successes[0];
                Account Set = Source.Accounts
                    .Where(i => i.Id == Entity.Pointer)
                    .AsNoTracking()
                    .FirstOrDefault()
                    ?? throw new Exception($"Item wasn't saved correctly {nameof(SecondFact)}");

                Assert.Equal(Entity.Pointer, Set.Id);
                Assert.Equal(Entity.User, Set.User);
                Assert.True(Entity.Password.SequenceEqual(Set.Password));

                Assert.True(Entity.EqualsSet(Set));

                Source.Remove(Set);
                Source.SaveChanges();
            },
        ]);
        #endregion  

        #region Third Fact Asserts (Creating a collection of Entities) 
        Assert.Multiple([
            () => Assert.Equal(3, ThirdFact.Successes.Count),
            () => Assert.Equal(2, ThirdFact.Failures.Count),
            () => {
                Assert.All(ThirdFact.Failures, 
                    (I) => {
                        Assert.Equal(OperationFailureCriterias.Entity, I.Criteria);
                });
            },
            () => {
                Assert.All(ThirdFact.Successes,
                    (I) => {
                        Assert.True(I.Pointer > 0);

                        Account Set = Source.Accounts
                            .Where(T => T.Id == I.Pointer)
                            .AsNoTracking()
                            .FirstOrDefault()
                            ?? throw new Exception($"Item wasn't saved correctly {nameof(ThirdFact)}({ThirdFact.Successes.IndexOf(I)})");

                        Assert.Equal(I.Pointer, Set.Id);
                        Assert.Equal(I.User, Set.User);
                        Assert.True(I.Password.SequenceEqual(Set.Password));

                        Assert.True(I.EqualsSet(Set));

                        Source.Remove(Set);
                        Source.SaveChanges();
                    });
            }
        ]);
        #endregion
    } 

    [Fact]
    public async void Read() {
        #region Pre-Tests 
        Account Set = Mocks[0].GenerateSet();
        await Source.AddAsync(Set);
        await Source.SaveChangesAsync();
        AccountEntity mockEntity = Set.GenerateEntity();
        #endregion 

        try {
            CriticalOperationResults FirstFact = await Repo.Read();
            CriticalOperationResults SecondFact = await Repo.Read(Behavior: ReadingBehavior.First);
            CriticalOperationResults ThirdFact = await Repo.Read(Behavior: ReadingBehavior.Last);

            CriticalOperationResults FifthFact = await Repo.Read([mockEntity.Pointer, 1000000000]);

            AccountEntity FourthFact = await Repo.Read(mockEntity.Pointer);

            #region First Fact Asserts (Reading all no filter) 
            Assert.Multiple([
                () => Assert.NotEmpty(FirstFact.Successes),
                () => Assert.Contains(mockEntity, FirstFact.Successes),
                () => Assert.Empty(FirstFact.Failures),
            ]);
            #endregion
            #region Second Fact Asserts (Reading first no filter) 
            Assert.Multiple([
                () => Assert.NotEmpty(SecondFact.Successes),
                () => Assert.Empty(SecondFact.Failures),
                () => Assert.Equal(1, SecondFact.Succeeded),
                () => Assert.Equal(0, SecondFact.Failed),
                () => Assert.Equal(1, SecondFact.Results),
                () => {
                    try {
                        Account FirstRecord = Source.Accounts.ToArray()[0];
                        AccountEntity FirstEntity = FirstRecord.GenerateEntity();

                        Assert.Equal(FirstEntity, SecondFact.Successes[0]);
                    } catch {
                        // --> This means that the first record in the live database set
                        // is an invalid one and should be debugged.
                        // DEVELOPER NOTE.
                        Assert.NotEmpty(SecondFact.Failures);
                        Assert.Empty(SecondFact.Successes);
                        Assert.Equal(1, SecondFact.Failed);
                        Assert.Equal(0, SecondFact.Succeeded);
                        Assert.Equal(1, SecondFact.Results);
                    }
                }
            ]);
            #endregion
            #region Third Fact Asserts (Reading last no filter)
            Assert.Multiple([
                () => Assert.Empty(ThirdFact.Failures),
                () => Assert.NotEmpty(ThirdFact.Successes),
                () => Assert.Equal(1, ThirdFact.Results),
                () => Assert.Equal(1, ThirdFact.Succeeded),
                () => Assert.Equal(0, ThirdFact.Failed),
                () => {
                    try {
                        Account Record = Source.Accounts.ToArray()[^1];
                        AccountEntity RecordEntity = Record.GenerateEntity();

                        Assert.Equal(RecordEntity, ThirdFact.Successes[0]);
                    } catch {
                        Assert.Empty(ThirdFact.Successes);
                        Assert.NotEmpty(ThirdFact.Failures);
                        Assert.Equal(1, ThirdFact.Results);
                        Assert.Equal(1, ThirdFact.Failed);
                        Assert.Equal(0, ThirdFact.Succeeded);
                    }
                }
            ]);
            #endregion
            
            #region Fourth Fact Asserts (Reading by pointer)
            Assert.Multiple([
                () => Assert.True(FourthFact.Pointer > 0),
                () => Assert.Equal(mockEntity, FourthFact),
                () => Assert.ThrowsAsync<XRecordUnfound<AccountsRepository>>(async () => await Repo.Read(1000000000)),
            ]);
            #endregion

            #region Fifth Fact Asserts (Reading pointer collection)
            Assert.Multiple([
                () => Assert.NotEmpty(FifthFact.Failures),
                () => Assert.NotEmpty(FifthFact.Successes),
                () => Assert.Equal(2, FifthFact.Results),
                () => Assert.Equal(1, FifthFact.Failed),
                () => Assert.Equal(1, FifthFact.Succeeded),
                () => {
                    AccountEntity Successed = FifthFact.Successes[0];
                    Assert.True(Successed.Pointer > 0);
                    Assert.Equal(mockEntity, Successed);
                },
                () => {
                    OperationFailure<Account> Failed = FifthFact.Failures[0];
                    Assert.Equal(typeof(Account), Failed.Type);
                    Assert.Equal(1000000000, Failed.Reference.Id);
                    Assert.Equal(OperationFailureCriterias.Pointer, Failed.Criteria);
                    Assert.IsType<XRecordUnfound<AccountsRepository>>(Failed.Failure);
                }
            ]);
            #endregion

        } finally {
            Source.Remove(Set);
            Source.SaveChanges();
        }
    }
}
