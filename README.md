This was a tricky challenge with a total stumbling block at section 14 when it came to handle penalties and extract the Journey class.

Here's the [irb text file](https://github.com/Whatapalaver/oyster_card/blob/master/doc/irb_test.txt) to test normal journeys (in then out) and two edge cases (in then in) and (out only).
Also added a final normal journey to catch the issue with tocuh-out only not adjusting the in_journey? status.

```ruby
 irb                                                                                                                                  ✔  10:36:14
2.5.1 :001 > # ALl 3 journeys together
 => nil
2.5.1 :002 > require './lib/oystercard.rb'
 => true
2.5.1 :003 > # journey 1 (normal fare expected)
 => nil
2.5.1 :004 > card = Oystercard.new
 => #<Oystercard:0x00007fc10d18df00 @balance=0, @journey_history=[]>
2.5.1 :005 > card.top_up(50)
 => 50
2.5.1 :006 > card.touch_in("North")
 => [{:entry_station=>"North", :exit_station=>nil}]
2.5.1 :007 > card.journey
 => #<Journey:0x00007fc10d115b68 @entry_station="North", @complete=false>
2.5.1 :008 > card.touch_out("South")
 => "South"
2.5.1 :009 > card.journey
 => nil
2.5.1 :010 > card.journey_history
 => [{:entry_station=>"North", :exit_station=>"South"}]
2.5.1 :011 > card.balance # expect 49
 => 49
2.5.1 :012 > # journey 2 (penalty fare expected)
 => nil
2.5.1 :013 > card.touch_in("Balham")
 => [{:entry_station=>"North", :exit_station=>"South"}, {:entry_station=>"Balham", :exit_station=>nil}]
2.5.1 :014 > card.journey
 => #<Journey:0x00007fc10f88a9a0 @entry_station="Balham", @complete=false>
2.5.1 :015 > card.touch_in("Moorgate")
 => nil
2.5.1 :016 > card.journey
 => nil
2.5.1 :017 > card.journey_history
 => [{:entry_station=>"North", :exit_station=>"South"}, {:entry_station=>"Balham", :exit_station=>"Double touch-in: Moorgate"}]
2.5.1 :018 > card.balance # expect 40
 => 40
2.5.1 :019 > # journey 3 (penalty fare expected)
 => nil
2.5.1 :020 > card.journey
 => nil
2.5.1 :021 > card.in_journey?
 => false
2.5.1 :022 > card.touch_out("Aldgate")
 => "Aldgate"
2.5.1 :023 > card.journey
 => nil
2.5.1 :024 > card.journey_history
 => [{:entry_station=>"North", :exit_station=>"South"}, {:entry_station=>"Balham", :exit_station=>"Double touch-in: Moorgate"}, {:entry_station=>nil,:exit_station=>"Aldgate"}]
2.5.1 :025 > card.balance # expect 31
 => 31
2.5.1 :026 > # journey 4 (normal)
 => nil
2.5.1 :027 > card.touch_in("Blue")
 => [{:entry_station=>"North", :exit_station=>"South"}, {:entry_station=>"Balham", :exit_station=>"Double touch-in: Moorgate"}, {:entry_station=>nil,:exit_station=>"Aldgate"}, {:entry_station=>"Blue", :exit_station=>nil}]
2.5.1 :028 > card.journey
 => #<Journey:0x00007fc10d1ed810 @entry_station="Blue", @complete=false>
2.5.1 :029 > card.touch_out("Red")
 => "Red"
2.5.1 :030 > card.journey
 => nil
2.5.1 :031 > card.journey_history
 => [{:entry_station=>"North", :exit_station=>"South"}, {:entry_station=>"Balham", :exit_station=>"Double touch-in: Moorgate"}, {:entry_station=>nil,:exit_station=>"Aldgate"}, {:entry_station=>"Blue", :exit_station=>"Red"}]
2.5.1 :032 > card.balance # expect 30
 => 30
2.5.1 :033 > exit
```

## Still Outstanding
### Section 15
- [ ] extract a JourneyLog class. It should be responsible for starting a journey, ending a journey and returning a list of journeys.
### Section 16
- [ ] Calculating fares between zones
```
In order to be charged the correct amount
As a customer
I need to have the correct fare calculated
```

