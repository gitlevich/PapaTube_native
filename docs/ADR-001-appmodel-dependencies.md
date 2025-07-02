# ADR-001: Heavy dependencies live in App composition root

Status: **Accepted** – 2025-07-02

## Context
`VideoService`, `PlaylistCache`, `PlaylistStore` are costly to create and shared by Onboarding, Player, etc.

## Decision
1. Build these objects once in the **composition root** (`PapaTubeApp`).
2. Pass them down **via constructor injection**.  
   No global singletons, no `Environment` keys, no DI framework.
3. Feature models (`PlayerModel`, `OnboardingModel`, …) receive domain data only (`Playlist`, flags).  They never create or store heavy services.

## Consequences
+ One ownership point, zero duplication.  
+ Compile-time safety—missing dependency fails to build.  
+ Tests inject mocks directly.  
− Slight boilerplate: constructors forward deps.

## Apply
```swift
let store = PlaylistStore(remote: VideoService(appConfig: AppConfig()),
                          local: PlaylistCache(ctx: container.mainContext))

WindowGroup {
    OnboardingView(store: store)
}
```
If a feature needs the store, thread it through initialisers.  Keep `AppModel` small: high-level state only. 