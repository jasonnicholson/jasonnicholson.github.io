+++
title = "Object-Oriented Programming Decline - The Rise of other Paradigms"
date = Date(2020, 11, 15)
tags = ["code"]
+++

I listen to a lot of computer science-related talks and podcasts. Recently, I have seen a trend away from the object-oriented paradigm. The premise is fusing your data and functions together is hard to maintain at scale. I agree. A better approach is only loosely to tie your data to the functions. I see this in the Julia language, for instance.

I watched several videos that led me to gather a little information on the issues. The first one was [Why Isn't Functional Programming the Norm? – Richard Feldman](https://youtu.be/QyJZzq0v7Z4). He talks about why object-oriented programming came to be the norm in the '90s and 2000s. The main reason he describes is Java. There is more to, but there isn't a strong reason why the industry embraced object-oriented programming.

Next, the following video showed up in my YouTube feed: [Object-Oriented Programming is Bad](https://www.youtube.com/watch?v=QM1iUe6IofM). The title is severe, and the content is less severe. The main issue comes back to that fusing your data and methods together doesn't scale well.

Lastly, I watched [JuliaCon 2019 | The Unreasonable Effectiveness of Multiple Dispatch | Stefan Karpinski](https://www.youtube.com/watch?v=kc9HwsxE1OY&t=68s) as I explore the Julia language. The Julia Language focuses on generic programming, which is amazing that the same code can be used for different data. Generic programming generally requires splitting the data out from the algorithm, which goes against object-oriented programming.
