import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:go_buddy_goo_mobile/modules/myaccount/ui/pages/new_ui/account_screen.dart';

import '../../modules/booking/ui/pages/bus_booking_detail.dart';
import '../../modules/booking/ui/pages/flight_booking_detail.dart';
import '../../modules/booking/ui/pages/hotel_booking_detail.dart';
import '../../modules/booking/ui/pages/rental_booking_detail.dart';
import '../../modules/booking/ui/pages/rental_booking_payment.dart';
import '../../modules/booking/ui/pages/tour_booking_detail.dart';
import '../../modules/bus/ui/pages/booking.dart';
import '../../modules/bus/ui/pages/bus.dart';
import '../../modules/bus/ui/pages/bus_detail.dart';
import '../../modules/bus/ui/pages/bus_offer_list.dart';
import '../../modules/bus/ui/pages/buslist.dart';
import '../../modules/flight/ui/pages/flightMain.dart';
import '../../modules/flight/ui/pages/flight_reserve.dart';
import '../../modules/flight/ui/pages/flight_search_result.dart';
import '../../modules/home/ui/pages/hotel_spotlights_list.dart';
import '../../modules/home/ui/pages/offers_list.dart';
import '../../modules/hotel/ui/pages/hotelBookingDetail.dart';
import '../../modules/hotel/ui/pages/hotelBookingPayment.dart';
import '../../modules/hotel/ui/pages/hotelDetailOffer.dart';
import '../../modules/hotel/ui/pages/hotelRoomDetail.dart';
import '../../modules/hotel/ui/pages/hotelRoomList.dart';
import '../../modules/hotel/ui/pages/hotelSearchResult.dart';
import '../../modules/hotel/ui/pages/hoteldetail.dart';
import '../../modules/hotel/ui/pages/searchhotel.dart';
import '../../modules/hotel/ui/pages/selectOnMap.dart';
import '../../modules/main/ui/pages/mainpage.dart';
import '../../modules/myaccount/ui/pages/activateAccount.dart';
import '../../modules/myaccount/ui/pages/myaccount.dart';
import '../../modules/myaccount/ui/pages/signup.dart';
import '../../modules/myaccount/ui/pages/updatePassword.dart';
import '../../modules/myaccount/ui/pages/updateProfile.dart';
import '../../modules/notification/ui/pages/bus_contact_detail_page.dart';
import '../../modules/notification/ui/pages/notification_page.dart';
import '../../modules/notification/ui/pages/offer_claim_page.dart';
import '../../modules/rental/ui/pages/guestDetail.dart';
import '../../modules/rental/ui/pages/rental.dart';
import '../../modules/rental/ui/pages/rentalBookingSuccess.dart';
import '../../modules/rental/ui/pages/rentalDetail.dart';
import '../../modules/rental/ui/pages/rentalOfferList.dart';
import '../../modules/rental/ui/pages/rentalSearchList.dart';
import '../../modules/tour/ui/pages/tour.dart';
import '../../modules/tour/ui/pages/tourBookingDetail.dart';
import '../../modules/tour/ui/pages/tourDetail.dart';
import '../../modules/tour/ui/pages/tourInquiry.dart';
import '../../modules/tour/ui/pages/tourSearchList.dart';
import '../../modules/tour/ui/pages/tourWithDiscountList.dart';
import '../pages/booking_success.dart';
import '../pages/error.dart';
import '../widgets/photoview.dart';

List<GetPage> routes = [
  GetPage(name: "/", page: () => const MainPage()),
  GetPage(name: "/main", page: () => const MainPage()),
  // GetPage(name: "/accountPage", page: () => const AccountPage()),
  GetPage(name: "/accountPage", page: () => const AccountScreen()),
  GetPage(name: "/updateProfile", page: () => const UpdateProfilePage()),
  GetPage(name: "/updatePassword", page: () => UpdatePasswordPage()),
  GetPage(name: "/activateAccount", page: () => const ActivateAccountPage()),
  GetPage(name: "/signUp", page: () => const SignUpPage()),
  GetPage(name: "/errorPage", page: () => ErrorPage()),
  GetPage(name: "/searchHotel", page: () => const SearchHotelPage()),
  GetPage(name: "/roomList", page: () => const HotelRoomListPage()),
  GetPage(name: "/hotelDetail", page: () => const HotelDetailPage()),
  GetPage(name: "/hotelDetailOffer", page: () => const HotelDetailOfferPage()),
  GetPage(name: "/hotelList", page: () => const HotelSearchResultPage()),
  GetPage(name: "/hotelOfferList", page: () => const HotelOffersListPage()),
  GetPage(name: "/hotelSpotlightList", page: () => HotelSpotlightListPage()),
  GetPage(name: "/searchFlight", page: () => const FlightMainPage()),
  GetPage(name: "/rentalPage", page: () => const RentalPage()),
  GetPage(name: "/roomDetail", page: () => HotelRoomDetailPage()),
  GetPage(name: "/bookingDetail", page: () => const HotelBookingDetailPage()),
  GetPage(name: "/rentalOffers", page: () => const RentalOfferListPage()),
  GetPage(name: "/busOffers", page: () => const BusOfferListPage()),
  GetPage(name: "/photoView", page: () => const PhotoViewPage()),
  GetPage(name: "/vehicleDetail", page: () => const RentalDetailPage()),
  GetPage(name: "/vehicleList", page: () => const RentalSearchListPage()),
  GetPage(name: "/hotelBookingPayment", page: () => HotelBookingPaymentPage()),
  GetPage(
      name: "/rentalBookingDetail", page: () => const RentalGuestDetailPage()),
  GetPage(name: "/tourPage", page: () => const TourPage()),
  GetPage(
      name: "/tourWithDiscounts", page: () => const TourWithDiscountListPage()),
  GetPage(name: "/tourDetail", page: () => const TourDetailPage()),
  GetPage(name: "/tourBookingDetail", page: () => const TourGuestDetailPage()),
  GetPage(name: "/tourList", page: () => const TourSearchListPage()),
  GetPage(name: "/tourQuery", page: () => const TourInquiryPage()),
  GetPage(name: "/searchBus", page: () => const BusSearchPage()),
  GetPage(name: "/busList", page: () => BusSearchList()),
  GetPage(name: "/rentalBookingSuccess", page: () => RentalBookingSuccess()),
  GetPage(name: "/busDetail", page: () => const BusDetailPage()),
  GetPage(name: "/busBookingConfirm", page: () => BusBookingConfirmation()),
  GetPage(name: "/bookingSuccess", page: () => const BookingSuccessPage()),
  GetPage(name: "/selectOnMap", page: () => const SelectOnMapPage()),
  GetPage(name: "/notification", page: () => const NotificationPage()),
  GetPage(name: "/buscontactdetail", page: () => const BusContactDetailPage()),
  GetPage(name: "/offerClaim", page: () => const OfferClaimPage()),
  GetPage(
      name: "/rentalBookedDetail", page: () => const RentalBookingDetailPage()),
  GetPage(name: "/busBookedDetail", page: () => const BusBookingDetailPage()),
  GetPage(
      name: "/hotelBookedDetail", page: () => const HotelBookedDetailPage()),
  GetPage(name: "/tourBookedDetail", page: () => const TourBookingDetailPage()),
  GetPage(
      name: "/flightBookedDetail", page: () => const FlightBookingDetailPage()),
  GetPage(name: "/rentalPayment", page: () => const RentalBookingPaymentPage()),
  GetPage(
      name: "/flightSearchResult", page: () => const FlightSearchResultPage()),
  GetPage(name: "/flightReserve", page: () => const FlightReservePage()),
];
