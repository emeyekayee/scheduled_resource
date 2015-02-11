# -*- coding: utf-8 -*-
# 
class ZTimeLabelHour < ZTimeLabel

  def self.get_timeblocks(id, t1, t2, inc)
    (super).each do |b|
      t = b.starttime
      b.title = t.strftime('%I:%M').sub(/^0/, '')     # '%I'
      b.css_classes = "ZTimeHeaderHourRow #{daylight_class(t)} "
    end
  end

  def self.daylight_class(t)
    (6...18).include?(t.hour) ? 'dayTimeblock' : 'niteTimeblock'
  end

  def self.end_for_start( t )
    floor(t) + 15.minutes
  end

  # t is a TimeWithZone or similar
  def self.floor(t)
    t.change(min: (t.min / 15) * 15)
  end

end
