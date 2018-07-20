This was a tricky challenge with a total stumbling block at section 14 when it came to handle penalties and extract the Journey class.

Here's the [irb text file]() to test normal journeys (in then out) and two edge cases (in then in) and (out only).

```ruby
 irb                                                                                                                             ✔  21:38:39
2.5.1 :001 > # ALl 3 journeys together
 => nil
2.5.1 :002 > require './lib/oystercard.rb'
 => true
2.5.1 :003 > card = Oystercard.new
 => #<Oystercard:0x00007fec530a1300 @balance=0, @journeys=[]>
2.5.1 :004 > card.top_up(50)
 => 50
2.5.1 :005 > card.touch_in("North")
 => [{:entry_station=>"North", :exit_station=>nil}]
2.5.1 :006 > card.journey
 => #<Journey:0x00007fec53090b18 @entry_station="North", @complete=false>
2.5.1 :007 > card.touch_out("South")
 => "South"
2.5.1 :008 > card.journey
 => nil
2.5.1 :009 > card.journeys
 => [{:entry_station=>"North", :exit_station=>"South"}]
2.5.1 :010 > card.balance
 => 49
2.5.1 :011 > # journey 2
 => nil
2.5.1 :012 > card.touch_in("Balham")
 => [{:entry_station=>"North", :exit_station=>"South"}, {:entry_station=>"Balham", :exit_station=>nil}]
2.5.1 :013 > card.journey
 => #<Journey:0x00007fec530522f0 @entry_station="Balham", @complete=false>
2.5.1 :014 > card.touch_in("Moorgate")
 => nil
2.5.1 :015 > card.journey
 => nil
2.5.1 :016 > card.journeys
 => [{:entry_station=>"North", :exit_station=>"South"}, {:entry_station=>"Balham", :exit_station=>"Moorgate"}]
2.5.1 :017 > card.balance
 => 40
2.5.1 :018 > # journey 3
 => nil
2.5.1 :019 > card.touch_out("Aldgate")
 => "Aldgate"
2.5.1 :020 > card.journey
 => nil
2.5.1 :021 > card.journeys
 => [{:entry_station=>"North", :exit_station=>"South"}, {:entry_station=>"Balham", :exit_station=>"Moorgate"}, {:entry_station=>nil, :exit_station=>"Aldgate"}]
2.5.1 :022 > card.balance
 => 31
```
