module CustomImprovementsHelper

  def options_for_select_tracker
    tracker = Tracker.all
    Tracker.all.map { |item| [item.name, item.id] }
  end


end

