#' Calculating Moving Average
#'
#' @param focal_date 
#' @param dates 
#' @param concentration 
#' @param win_size_wks 
#'
#' @returns result
#' @export
#'
#' @examples
#' ca_ma_once <- moving_average(focal_date, dates, concentration, win_size_wks)
moving_average <- function(focal_date, dates, concentration, win_size_wks) {
  
  # Which dates are in the window?
  is_in_window <- (dates > focal_date - (win_size_wks / 2) * 7) &
    (dates < focal_date + (win_size_wks / 2) * 7)
  
  # Find the associated concentration
  window_concentration <- concentration[is_in_window]
  
  # Calculate the mean
  result <- mean(window_concentration)
  
  return(result)
  
}