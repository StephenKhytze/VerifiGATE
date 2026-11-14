-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 07, 2026 at 10:43 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.5.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aced_database`
--
DROP DATABASE IF EXISTS `aced_database`;
CREATE DATABASE IF NOT EXISTS `aced_database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `aced_database`;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `admin_user_name` varchar(20) NOT NULL,
  `admin_password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `admin_user_name`, `admin_password`) VALUES
(1, 'admin123', '12345');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `product_id` int(11) NOT NULL,
  `product_name` text NOT NULL,
  `product_category` varchar(20) NOT NULL,
  `product_pic` varchar(100) NOT NULL,
  `product_description` text NOT NULL,
  `product_discount` int(11) DEFAULT NULL,
  `product_price` int(11) NOT NULL,
  `product_sold` int(11) NOT NULL,
  `product_rating` float DEFAULT NULL,
  `product_stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`product_id`, `product_name`, `product_category`, `product_pic`, `product_description`, `product_discount`, `product_price`, `product_sold`, `product_rating`, `product_stock`) VALUES
(1, 'Myths of Ancient Greece - Wished Novel Release', 'historical', 'http://localhost/HCI%20Elec%20Project/Books/images/historical_placeholder_1.jpg', 'Explore timeless legends in this long-awaited novelized retelling of Ancient Greece’s greatest myths. From tragic heroes to cunning gods, each story comes to life with emotional depth and dramatic flair. A perfect blend of scholarship and storytelling for modern readers.', 800, 928, 5, 0, 2495),
(2, 'The Fate of Olympus by Robert Brown ', 'historical', 'http://localhost/HCI%20Elec%20Project/Books/images/historical_placeholder_2.jpg', 'Robert Brown delivers a gripping account of the final days of the Greek gods. With historical insight and vivid imagination, The Fate of Olympus explores what happens when divine power fades. A must-read for mythology and history enthusiasts alike.', NULL, 567, 1320, 3.3, 2501),
(3, 'Royal Gods of China by Li Youmei', 'historical', 'http://localhost/HCI%20Elec%20Project/Books/images/historical_placeholder_3.jpg', 'Dive into the sacred courts of Chinese deities with Li Youmei’s masterful chronicle. Royal Gods of China unveils the divine hierarchies, spiritual rituals, and mythic battles that shaped ancient dynasties. A compelling journey through folklore and imperial worship.', 670, 700, 1312, 5, 2500),
(4, 'The Egyptian Pantheon by Layla El-fouly', 'historical', 'http://localhost/HCI%20Elec%20Project/Books/images/historical_placeholder_4.jpg', 'Discover the divine drama behind the ancient Nile in this rich exploration of Egypt’s gods. Layla el-Fouly brings Ra, Anubis, Isis, and others to life through archaeological insights and captivating storytelling. A scholarly yet accessible guide to one of history’s most enigmatic religions.', NULL, 500, 199, 4.5, 2501),
(5, 'HADES: The Hidden Story by John Novel', 'historical', 'http://localhost/HCI%20Elec%20Project/Books/images/historical_placeholder_5.jpg', 'Unveil the underworld like never before in HADES: The Hidden Story. John Novel reimagines the god of the dead with humanity, power, and secrets long buried in myth. Dark, introspective, and unforgettable.', 900, 1023, 4959, 5, 4960),
(6, 'Sailor Moon Complete Collection', 'manga', 'http://localhost/HCI%20Elec%20Project/Books/images/manga_placeholder.jpg', 'Relive the magic of Sailor Moon with this complete box set featuring every chapter of the iconic series. Join Usagi and her fellow Sailor Guardians as they protect Earth from cosmic threats. A must-have for collectors and magical girl fans alike.\n\n', 4000, 4318, 4534, 3.5, 4513),
(7, 'Life as a Roman Myth Complete Set', 'manga', 'http://localhost/HCI%20Elec%20Project/Books/images/manga_placeholder_2.jpg', 'Myth meets manga in this stylized retelling of Roman legends, told through the eyes of a mischievous demi-god. With bold art and clever dialogue, this collection reinvents classical tales for a modern audience. All volumes included in one premium set.', NULL, 940, 1332, 4.5, 2501),
(8, 'Angels of Hera - First Edition', 'manga', 'http://localhost/HCI%20Elec%20Project/Books/images/manga_placeholder_3.jpg', 'This rare collector’s set features the original first edition of Angels of Hera, a high-action, goddess-powered saga set in a mythic modern world. With limited edition art cards and exclusive bonus chapters, it’s a treasure for any fan of divine drama.', 670, 759, 1011, 4.6, 2499),
(9, 'GRECO-CONTROL - Unopened Collector\'s Edition', 'manga', 'http://localhost/HCI%20Elec%20Project/Books/images/manga_placeholder_4.jpg', 'A dystopian Greece ruled by AI gods comes to life in GRECO-CONTROL. This sealed box set includes all volumes of the cult-favorite manga that blends mythology and cyberpunk. Unopened, untouched, and dangerously addictive.', NULL, 1230, 453, 4.7, 2500),
(10, 'PERSEPHONE - 2007 Collector\'s Edition', 'manga', 'http://localhost/HCI%20Elec%20Project/Books/images/manga_placeholder_5.jpg', 'Revisit the haunting romance between Hades and Persephone in this beautifully illustrated, emotionally charged manga series. The 2007 collection includes all original volumes and bonus author commentary. A dark love story you won’t forget.', 2300, 2543, 123, 4.1, 2500),
(11, 'CONCLAVE by Robert Harris', 'novel', 'http://localhost/HCI%20Elec%20Project/Books/images/novel_placeholder_1.jpg', 'In the heart of the Vatican, secrets and politics collide as cardinals gather to elect a new Pope. CONCLAVE is a fast-paced, deeply human thriller that explores faith, ambition, and power. Harris delivers intrigue with razor-sharp precision.', 600, 678, 6514, 4.3, 2477),
(12, 'The Odyssey by Homer', 'novel', 'http://localhost/HCI%20Elec%20Project/Books/images/novel_placeholder_2.avif', 'Homer’s epic masterpiece follows Odysseus’s perilous journey home after the Trojan War. Gods, monsters, and fate entwine in this cornerstone of Western literature. Timeless and essential.\n\n', NULL, 567, 5324, 5, 2498),
(13, 'The Moon Goddess by Jary Chapilan', 'novel', 'http://localhost/HCI%20Elec%20Project/Books/images/novel_placeholder_3.jpg', 'A forgotten goddess awakens under the glow of a lunar eclipse in this lyrical fantasy. The Moon Goddess blends mythology, love, and cosmic mystery in a tale both ancient and modern. A poetic odyssey through darkness and destiny.', 670, 759, 3327, 4.3, 2500),
(14, 'The Last God of China by Bally Repren', 'novel', 'http://localhost/HCI%20Elec%20Project/Books/images/novel_placeholder_4.jpg', 'In a world where belief fuels reality, the last god of China struggles to survive in an unbelieving age. Bally Repren’s novel is both epic and intimate, weaving mythology with contemporary themes. A profound exploration of divinity and identity.', 750, 800, 54, 2, 2499),
(15, 'My Love on Olympus by Ron Malort', 'novel', 'http://localhost/HCI%20Elec%20Project/Books/images/novel_placeholder_5.jpg', 'When a mortal woman falls for a god, Olympus itself begins to tremble. My Love on Olympus is a passionate tale of forbidden romance, divine interference, and fate’s cruel games. Romantic, tragic, and utterly mythic.', 670, 700, 495, 4.3, 2500),
(16, 'Saint Seiya Volume 1 Complete Japanese Release', 'manga', 'http://localhost/HCI%20Elec%20Project/Books/images/manga_placeholder_6.jpg', 'Experience the legendary battles of the Saints in their original Japanese editions. This set includes volumes 1–7, showcasing stunning artwork and the epic saga of Seiya and the Zodiac warriors. For purists, collectors, and fans of classic shonen action.', 2200, 2500, 201, 4, 204);

-- --------------------------------------------------------

--
-- Table structure for table `canceled_orders`
--

CREATE TABLE `canceled_orders` (
  `canceled_orders_id` int(11) NOT NULL,
  `canceled_orders_group_id` varchar(11) NOT NULL,
  `canceled_orders_date_ordered` date NOT NULL,
  `canceled_orders_date_canceled` date NOT NULL,
  `canceled_orders_product_id` int(11) NOT NULL,
  `canceled_orders_product_type` varchar(20) NOT NULL,
  `canceled_orders_quantity` int(11) NOT NULL,
  `canceled_orders_reason` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `canceled_orders`
--

INSERT INTO `canceled_orders` (`canceled_orders_id`, `canceled_orders_group_id`, `canceled_orders_date_ordered`, `canceled_orders_date_canceled`, `canceled_orders_product_id`, `canceled_orders_product_type`, `canceled_orders_quantity`, `canceled_orders_reason`) VALUES
(1, '91744a', '2025-05-19', '2025-05-25', 6, 'books', 1, ''),
(2, '91744a', '2025-05-19', '2025-05-25', 2, 'books', 1, ''),
(3, '91744a', '2025-05-19', '2025-05-25', 7, 'books', 1, ''),
(7, 'ff1f5e', '2025-05-24', '2025-05-25', 6, 'books', 1, 'Wrong item selected'),
(8, '102708', '2025-05-26', '2025-05-26', 6, 'books', 1, 'Wrong or out-of-date address'),
(9, '6df54c', '2025-05-24', '2025-05-27', 1, 'books', 1, 'Wrong or out-of-date address'),
(10, '30a365', '2025-05-25', '2025-05-27', 16, 'books', 1, 'lol'),
(11, 'a518d3', '2025-05-27', '2025-05-27', 6, 'books', 1, 'Wrong or out-of-date address'),
(12, 'a518d3', '2025-05-27', '2025-05-27', 10, 'merch', 1, 'Wrong or out-of-date address'),
(13, 'ae9b27', '2025-05-27', '2025-05-27', 6, 'books', 1, 'Wrong or out-of-date address');

-- --------------------------------------------------------

--
-- Table structure for table `completed_orders`
--

CREATE TABLE `completed_orders` (
  `completed_orders_id` int(11) NOT NULL,
  `completed_orders_group_id` varchar(11) NOT NULL,
  `completed_orders_date_ordered` date NOT NULL,
  `completed_orders_date_completed` date NOT NULL,
  `completed_orders_product_id` int(11) NOT NULL,
  `completed_orders_product_type` varchar(20) NOT NULL,
  `completed_orders_quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `completed_orders`
--

INSERT INTO `completed_orders` (`completed_orders_id`, `completed_orders_group_id`, `completed_orders_date_ordered`, `completed_orders_date_completed`, `completed_orders_product_id`, `completed_orders_product_type`, `completed_orders_quantity`) VALUES
(1, '31fe22', '2025-05-23', '2025-05-25', 6, 'books', 1),
(2, '31fe22', '2025-05-23', '2025-05-25', 16, 'books', 1),
(3, '632468', '2025-05-22', '2025-05-25', 5, 'books', 1),
(4, '632468', '2025-05-22', '2025-05-25', 12, 'books', 5),
(5, 'cb1579', '2025-05-21', '2025-05-25', 11, 'books', 1),
(6, '086faa', '2025-05-24', '2025-05-25', 5, 'books', 1),
(7, '58860e', '2025-05-20', '2025-05-25', 5, 'books', 3),
(8, '3b45f4', '2025-05-20', '2025-05-25', 11, 'books', 9),
(9, 'fa8287', '2025-05-24', '2025-05-25', 1, 'books', 1),
(10, '3b4e1e', '2025-05-24', '2025-05-25', 6, 'books', 1),
(11, '3b4e1e', '2025-05-24', '2025-05-25', 6, 'books', 1),
(12, '536fe1', '2025-05-26', '2025-05-26', 6, 'books', 1),
(13, '536fe1', '2025-05-26', '2025-05-26', 5, 'books', 1),
(14, '793059', '2025-05-26', '2025-05-26', 1, 'merch', 1),
(15, '536fe1', '2025-05-26', '2025-05-26', 6, 'books', 1),
(16, '536fe1', '2025-05-26', '2025-05-26', 5, 'books', 1),
(17, '536fe1', '2025-05-26', '2025-05-26', 6, 'books', 1),
(18, '536fe1', '2025-05-26', '2025-05-26', 5, 'books', 1),
(19, '793059', '2025-05-26', '2025-05-26', 1, 'merch', 1),
(20, '793059', '2025-05-26', '2025-05-26', 1, 'merch', 1),
(21, '8f16d7', '2025-05-24', '2025-05-26', 16, 'books', 5),
(22, '3b4e1e', '2025-05-24', '2025-05-26', 6, 'books', 1),
(23, '536fe1', '2025-05-26', '2025-05-26', 6, 'books', 1),
(24, '536fe1', '2025-05-26', '2025-05-26', 5, 'books', 1),
(26, '0b72fa', '2025-05-26', '2025-05-26', 11, 'books', 1),
(27, '0b72fa', '2025-05-26', '2025-05-26', 5, 'books', 1),
(28, '0b72fa', '2025-05-26', '2025-05-26', 16, 'books', 1),
(29, '0b72fa', '2025-05-26', '2025-05-26', 3, 'books', 1),
(30, '0b72fa', '2025-05-26', '2025-05-26', 2, 'books', 1),
(31, '082797', '2025-05-26', '2025-05-26', 6, 'books', 1),
(32, '082797', '2025-05-26', '2025-05-26', 3, 'books', 1),
(33, '082797', '2025-05-26', '2025-05-26', 14, 'books', 1),
(34, '082797', '2025-05-26', '2025-05-26', 2, 'books', 1),
(35, '082797', '2025-05-26', '2025-05-26', 1, 'books', 1),
(36, '167563', '2025-05-26', '2025-05-26', 6, 'books', 1),
(37, '167563', '2025-05-26', '2025-05-26', 11, 'books', 7),
(38, '167563', '2025-05-26', '2025-05-26', 14, 'books', 1),
(39, '167563', '2025-05-26', '2025-05-26', 4, 'books', 1),
(40, '167563', '2025-05-26', '2025-05-26', 8, 'books', 1),
(41, '94072f', '2025-05-26', '2025-05-26', 6, 'books', 1),
(42, '94072f', '2025-05-26', '2025-05-26', 1, 'books', 5),
(43, '94072f', '2025-05-26', '2025-05-26', 6, 'books', 1),
(44, '94072f', '2025-05-26', '2025-05-26', 1, 'books', 5),
(45, '94072f', '2025-05-26', '2025-05-26', 6, 'books', 1),
(46, '94072f', '2025-05-26', '2025-05-26', 1, 'books', 5),
(47, 'ef1668', '2025-05-26', '2025-05-26', 1, 'books', 5),
(48, '8fd981', '2025-05-26', '2025-05-26', 6, 'books', 1),
(49, 'e81dc4', '2025-05-26', '2025-05-26', 6, 'books', 1),
(50, 'de1d2a', '2025-05-26', '2025-05-26', 12, 'books', 1),
(51, '86f741', '2025-05-26', '2025-05-26', 6, 'books', 1),
(52, 'cc4aec', '2025-05-26', '2025-05-26', 6, 'books', 1),
(53, '66a258', '2025-05-26', '2025-05-26', 6, 'books', 1),
(54, '5097b5', '2025-05-26', '2025-05-26', 6, 'books', 1),
(55, '3cafcb', '2025-05-26', '2025-05-26', 6, 'books', 1),
(56, '469a1e', '2025-05-26', '2025-05-26', 6, 'books', 1),
(57, 'a7c0cc', '2025-05-26', '2025-05-26', 6, 'books', 1),
(58, '279736', '0000-00-00', '0000-00-00', 0, '', 0),
(59, '60b9c3', '2025-05-26', '2025-05-26', 12, 'books', 1),
(60, 'e3fcc0', '2025-05-26', '2025-05-26', 11, 'books', 1),
(61, '33c8f6', '2025-05-27', '2025-05-27', 11, 'books', 13),
(62, '33c8f6', '2025-05-27', '2025-05-27', 18, 'merch', 12),
(63, '1a2764', '2025-05-27', '2025-05-27', 6, 'books', 1),
(64, '112d08', '2025-05-26', '2025-05-27', 6, 'books', 1),
(65, '2781eb', '2025-05-26', '2025-05-27', 6, 'books', 1),
(66, '1447d8', '2025-05-27', '2025-05-27', 6, 'books', 2);

-- --------------------------------------------------------

--
-- Table structure for table `merch`
--

CREATE TABLE `merch` (
  `product_id` int(11) NOT NULL,
  `product_name` text NOT NULL,
  `product_category` varchar(20) NOT NULL,
  `product_pic` varchar(100) NOT NULL,
  `product_description` text NOT NULL,
  `product_discount` int(11) DEFAULT NULL,
  `product_price` int(11) NOT NULL,
  `product_sold` int(11) NOT NULL,
  `product_rating` float DEFAULT NULL,
  `product_stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `merch`
--

INSERT INTO `merch` (`product_id`, `product_name`, `product_category`, `product_pic`, `product_description`, `product_discount`, `product_price`, `product_sold`, `product_rating`, `product_stock`) VALUES
(9, 'Golden Bull Keychain', 'norse', '../Merch/images/merch_img_9.jpg', 'Golden Bull Keychain', 0, 50, 4, NULL, 100),
(10, 'Sacred Stag Photocard', 'norse', '../Merch/images/merch_img_10.jpg', 'Sacred Stag Photocard', 55, 60, 4622, 4.8, 110),
(11, 'Valkyrie Necklace ', 'norse', '../Merch/images/merch_img_11.jpg', 'Valkyrie Necklace ', NULL, 560, 5, NULL, 400),
(12, 'Mythos Socks', 'norse', '../Merch/images/merch_img_12.jpg', 'Mythos Socks', 60, 70, 23, NULL, 1200),
(13, 'Zeus 3D Wall Art Poster', 'greek', '../Merch/images/merch_img_13.jpg', 'Zeus 3D Wall Art Poster', 220, 250, 73, NULL, 400),
(14, 'Burial Bust Keychain', 'greek', '../Merch/images/merch_img_14.jpg', 'Burial Bust Keychain', NULL, 150, 673, NULL, 213),
(15, 'Empress of Athens Headpiece/Necklace', 'greek', '../Merch/images/merch_img_15.jpg', 'Empress of Athens Headpiece/Necklace', NULL, 500, 32, 3.3, 400),
(16, 'Bust Sticker (20pcs)', 'greek', '../Merch/images/merch_img_16.jpg', 'Bust Sticker (20pcs)', 30, 50, 2, NULL, 1000),
(17, 'Winged Victory Pendant', 'greek', '../Merch/images/merch_img_17.jpg', 'Winged Victory Pendant', 530, 600, 2304, 2.7, 600),
(18, 'Emperor\'s Seal Keychain', 'asian', '../Merch/images/merch_img_18.jpg', 'Emperor\'s Seal Keychain', 220, 250, 3002, NULL, 400),
(19, 'Lucky Jumping Lion Keychain', 'asian', '../Merch/images/merch_img_19.jpg', 'Lucky Jumping Lion Keychain', 190, 200, 877, NULL, 400),
(20, 'Cambodian God of Wrath Tribal Poster', 'asian', '../Merch/images/merch_img_20.jpg', 'Cambodian God of Wrath Tribal Poster', 200, 250, 5, 3, 400),
(21, 'Sky Buddha Poster', 'asian', '../Merch/images/merch_img_21.jpg', 'Sky Buddha Poster', 90, 100, 87, NULL, 500),
(22, 'Traditional Chinese-inspired Women\'s Necklace ', 'asian', '../Merch/images/merch_img_22.jpg', 'Traditional Chinese-inspired Women\'s Necklace ', 220, 250, 2874, NULL, 500),
(23, 'Pharaoh\'s Tomb Socks', 'egypt', '../Merch/images/merch_img_23.jpg', 'Pharaoh\'s Tomb Socks', NULL, 100, 32, 2.6, 400),
(24, 'King Tut Keychain', 'egypt', '../Merch/images/merch_img_24.jpg', 'King Tut Keychain', 120, 150, 2, NULL, 500),
(25, 'Statuette Candle Holder', 'egypt', '../Merch/images/merch_img_25.jpg', 'Statuette Candle Holder', 450, 500, 1, 4, 500),
(26, 'Queen Hatshepsut Necklace', 'egypt', '../Merch/images/merch_img_26.jpg', 'Queen Hatshepsut Necklace', 370, 400, 2453, NULL, 600),
(27, '\'Queen of the Nile\' Long Earrings', 'egypt', '../Merch/images/merch_img_27.jpg', '\'Queen of the Nile\' Long Earrings', NULL, 250, 3949, 2, 500),
(28, 'Roman Christianization Poster', 'roman', '../Merch/images/merch_img_28.jpg', 'Roman Christianization Poster', 220, 250, 4523, 5, 500),
(29, 'Apollo Minimalist Poster', 'roman', '../Merch/images/merch_img_29.jpg', 'Apollo Minimalist Poster', 150, 170, 5, NULL, 200),
(30, 'Temptation of Odysseus Poster', 'roman', '../Merch/images/merch_img_30.jpg', 'Temptation of Odysseus Poster', 300, 320, 234, 3.6, 500),
(31, 'Hermes Golden Necklace', 'roman', '../Merch/images/merch_img_31.jpg', 'Hermes Golden Necklace', 520, 600, 4573, 4.5, 400),
(32, 'Blackstone Early-roman-inspired Bracelet', 'roman', '../Merch/images/merch_img_32.jpg', 'Blackstone Early-roman-inspired Bracelet', NULL, 500, 3434, NULL, 200),
(33, 'Krishnu Socks', 'hindu', '../Merch/images/merch_img_33.jpg', 'Krishnu Socks', 320, 350, 45, 4, 500),
(34, 'Brahman Dreamcatcher', 'hindu', '../Merch/images/merch_img_34.jpg', 'Brahman Dreamcatcher', 0, 400, 40, NULL, 400),
(35, 'Vishnu and Kali Statue', 'hindu', '../Merch/images/merch_img_35.jpg', 'Vishnu and Kali Statue', 1100, 1200, 20, NULL, 500),
(36, 'Brahman Statue', 'hindu', '../Merch/images/merch_img_36.jpg', 'Brahman Statue', 2420, 2500, 2, NULL, 560),
(38, 'Peace in Hindustan Statue', 'hindu', '../Merch/images/merch_img_37.jpg', 'Peace in Hindustan Statue', 3720, 3872, 103, NULL, 340),
(39, 'Portal to Valhalla Poster', 'norse', '../Merch/images/merch_img_39.jpg', 'Portal to Valhalla Poster', 0, 130, 2345, NULL, 500),
(40, 'Zeus', 'greek', '../Merch/images/merch_img_40.jpg', 'Zeus Poster', 500, 1000, 0, NULL, 500);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `orders_id` int(11) NOT NULL,
  `orders_group_id` varchar(11) DEFAULT NULL,
  `orders_date` date NOT NULL,
  `orders_user_id` int(11) NOT NULL,
  `orders_product_id` int(11) NOT NULL,
  `orders_product_type` varchar(20) NOT NULL,
  `orders_quantity` int(11) NOT NULL,
  `orders_status` varchar(20) DEFAULT NULL,
  `orders_cancel_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orders_id`, `orders_group_id`, `orders_date`, `orders_user_id`, `orders_product_id`, `orders_product_type`, `orders_quantity`, `orders_status`, `orders_cancel_reason`) VALUES
(18, '56627d', '2025-05-23', 7, 6, 'books', 3, 'for delivery', ''),
(19, '56627d', '2025-05-23', 7, 5, 'books', 1, 'for delivery', ''),
(86, 'b9cd2d', '2025-05-27', 1, 6, 'books', 1, 'pending', NULL),
(87, 'b9cd2d', '2025-05-27', 1, 3, 'books', 1, 'pending', NULL),
(88, 'b9cd2d', '2025-05-27', 1, 27, 'merch', 1, 'pending', NULL),
(89, '7a85a2', '2025-05-27', 1, 8, 'books', 1, 'pending', NULL),
(90, 'd1d574', '2025-05-27', 1, 6, 'books', 1, 'pending', NULL),
(91, '9bcaa1', '2025-05-27', 1, 14, 'books', 1, 'pending', NULL),
(92, NULL, '2025-05-27', 1, 6, 'books', 1, 'in cart', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `review_product_id` int(11) NOT NULL,
  `review_product_type` varchar(20) NOT NULL,
  `review_product_category` varchar(20) NOT NULL,
  `review_user_id` int(11) NOT NULL,
  `review_user_rating` float NOT NULL,
  `review_text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`review_id`, `review_product_id`, `review_product_type`, `review_product_category`, `review_user_id`, `review_user_rating`, `review_text`) VALUES
(1, 11, 'books', 'novel', 1, 5, 'This is a good book'),
(2, 14, 'books', 'novel', 1, 2, 'This book is too overpriced'),
(4, 11, 'books', 'novel', 1, 4, 'You might become bored by this dutiful recounting of facts, or you may welcome every eploying all possible resources, Conclave doggedly sets out to provide readers with the fundamental satisfactions of story: of sequence, configuration and organisation. I have no idea if Harris shapes his books as he proceeds – like a potter at the wheel – or if he works from some complex set of outlines and notes. What I do know is that in Conclave the sequence is very simple and pleasing indeed: the pope dies, the cardinals gather, there is the first ballot, there is the second ballot, there is the third ballot, and so on, each stage being accompanied by another twist, some new mystery or complication.'),
(5, 11, 'books', 'novel', 1, 4, 'I liked the part when the conclave happened and the cardinals started to conclave all over themselves'),
(6, 11, 'books', 'novel', 1, 5, 'Robert Harris’ Conclave is the tale of a papal succession by a well-known author who’s written the alternate history classic Fatherland. He does not have the cardinals face off against crazy bikers. But he does have them encounter what seems like everything else. The writing itself is often good, and certainly Harris’ skill is on display. The setup of the book is excellent, save for a contrivance where a secret cardinal manages to slip into the conclave in spite of historical precedent.\r\n\r\n'),
(7, 11, 'books', 'novel', 1, 5, ''),
(8, 11, 'books', 'test', 1, 5, 'sffasfasfsfsffafffasfsa'),
(9, 11, 'books', 'test', 1, 5, 'I liked the plot'),
(10, 6, 'books', 'test', 1, 5, 'i love sailor moon'),
(11, 6, 'books', 'test', 1, 1, 'I HATE SAILOR MOON!!!!!!!!!!!!'),
(12, 6, 'books', 'test', 1, 3, 'I\'m impartial about sailor moon.'),
(13, 6, 'books', 'test', 1, 5, 'Sailor Moon is my favorite series'),
(14, 5, 'books', 'test', 1, 5, 'There should be more books like this'),
(15, 11, 'books', 'test', 1, 1, 'I don\'t like this.'),
(16, 33, 'merch', 'test', 1, 5, 'i love krishnu'),
(17, 33, 'merch', 'test', 1, 5, 'i love krishnu'),
(18, 33, 'merch', 'test', 1, 2, 'INDIA NUMBER 1!!!!!!!!!!!!! Hail our Goddess\r\n');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `sales_id` int(11) NOT NULL,
  `sales_order_code` varchar(10) NOT NULL,
  `sales_date_and_time` date NOT NULL,
  `sales_payment_type` varchar(11) NOT NULL,
  `sales_revenue` int(11) NOT NULL,
  `sales_is_paid` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`sales_id`, `sales_order_code`, `sales_date_and_time`, `sales_payment_type`, `sales_revenue`, `sales_is_paid`) VALUES
(4, '58860e', '2025-05-20', 'Kuripot', 2976, 0),
(5, '3b45f4', '2025-05-20', 'Kuripot', 6054, 0),
(6, 'cb1579', '2025-05-20', 'Malimos', 13236, 0),
(7, '632468', '2025-05-22', 'COD', 3735, 0),
(8, '56627d', '2025-05-23', 'Kuripot', 13566, 0),
(9, '31fe22', '2025-05-23', 'Kuripot', 6200, 0),
(10, '8f16d7', '2025-05-24', 'Kuripot', 12230, 1),
(12, '3b4e1e', '2025-05-24', 'COD', 4030, 1),
(13, '086faa', '2025-05-24', 'COD', 930, 0),
(15, '61f793', '2025-05-24', 'COD', 830, 0),
(16, 'fa8287', '2025-05-24', 'COD', 830, 0),
(18, '0b72fa', '2025-05-26', 'COD', 8967, 1),
(20, '793059', '2025-05-26', 'COD', 32, 1),
(21, '082797', '2025-05-26', 'Kuripot', 6817, 1),
(22, '167563', '2025-05-26', 'Malimos', 10618, 1),
(23, '94072f', '2025-05-26', 'Kuripot', 8542, 1),
(24, 'ef1668', '2025-05-26', 'COD', 4542, 1),
(25, '8fd981', '2025-05-26', 'COD', 4030, 1),
(26, 'e81dc4', '2025-05-26', 'COD', 4030, 1),
(27, 'de1d2a', '2025-05-26', 'COD', 597, 1),
(28, '86f741', '2025-05-26', 'COD', 4030, 1),
(29, 'cc4aec', '2025-05-26', 'COD', 4030, 1),
(30, '66a258', '2025-05-26', 'COD', 4030, 1),
(31, '5097b5', '2025-05-26', 'COD', 4030, 1),
(32, '3cafcb', '2025-05-26', 'Kuripot', 4030, 1),
(33, '469a1e', '2025-05-26', 'Kuripot', 4030, 1),
(34, 'a7c0cc', '2025-05-26', 'COD', 4030, 1),
(35, '279736', '2025-05-26', 'COD', 4030, 1),
(36, '60b9c3', '2025-05-26', 'COD', 597, 1),
(37, 'e3fcc0', '2025-05-26', 'COD', 630, 1),
(38, '112d08', '2025-05-26', 'COD', 4030, 1),
(39, '2781eb', '2025-05-26', 'COD', 4030, 1),
(41, '1a2764', '2025-05-27', 'COD', 4030, 1),
(42, '33c8f6', '2025-05-27', 'Kuripot', 11736, 1),
(43, '1447d8', '2025-05-27', 'Kuripot', 8318, 1),
(45, 'b9cd2d', '2025-05-27', 'COD', 4950, 0),
(46, '7a85a2', '2025-05-27', 'COD', 700, 0),
(47, 'd1d574', '2025-05-27', 'COD', 4030, 0),
(48, '9bcaa1', '2025-05-27', 'COD', 780, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(25) NOT NULL,
  `email` varchar(35) NOT NULL,
  `password` varchar(20) NOT NULL,
  `contact_no` varchar(20) NOT NULL,
  `address` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `email`, `password`, `contact_no`, `address`) VALUES
(1, 'Juan Dela Cruz', 'assss@a.com', 'a', '09660234343', '123 Maria St., Brgy. Alfresco, Luzon, Philippines'),
(2, 'Test ', 'a@b.com', 'asd', '09121213144', 'a'),
(5, 'Marc M. Asuncion', 'testing@trial.com', 'asdfghjkl', '09192837589', '123 Among Us St., Among Us, Among A'),
(6, 'test 1', 'test@gmail.com', 'pop', '09192837589', 'testing street'),
(7, 'Sample Account', 'sample@account.com', '123', '09192837589', 'Sample Address'),
(8, 'Test ', 'a@a.com', 'a', '09192837589', 'a'),
(9, 'Test ', 'assass@a.com', 'a', '09121213144', ''),
(10, 'Blank Account', 'blank@blank.com', 'b', '09121213144', '0 Blank St., Brgy. Blanco, Luzon, Philippines'),
(11, 'Paul William Quiliope', 'paulquiliope0625@gmail.com', '123456789', '09205731696', '866 Pagkakaisa St., Brgy VI-D, San Pablo City, Laguna, Philippines, 4000'),
(12, 'Test ', 'test2@gmail.com', '123', '09121213144', '123 Test, Brgy. Test, Philippines, Test');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `canceled_orders`
--
ALTER TABLE `canceled_orders`
  ADD PRIMARY KEY (`canceled_orders_id`);

--
-- Indexes for table `completed_orders`
--
ALTER TABLE `completed_orders`
  ADD PRIMARY KEY (`completed_orders_id`);

--
-- Indexes for table `merch`
--
ALTER TABLE `merch`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orders_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sales_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `canceled_orders`
--
ALTER TABLE `canceled_orders`
  MODIFY `canceled_orders_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `completed_orders`
--
ALTER TABLE `completed_orders`
  MODIFY `completed_orders_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `merch`
--
ALTER TABLE `merch`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `orders_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sales_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- Database: `haa_med_center_pms_database`
--
DROP DATABASE IF EXISTS `haa_med_center_pms_database`;
CREATE DATABASE IF NOT EXISTS `haa_med_center_pms_database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `haa_med_center_pms_database`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_patient_records`
--

CREATE TABLE `tbl_patient_records` (
  `ID` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `patient_first_name` varchar(255) NOT NULL,
  `patient_middle_name` varchar(255) DEFAULT NULL,
  `patient_last_name` varchar(255) NOT NULL,
  `patient_birthday` datetime NOT NULL,
  `patient_address` text NOT NULL,
  `patient_contact_number` varchar(20) NOT NULL,
  `patient_sex` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_patient_records`
--

INSERT INTO `tbl_patient_records` (`ID`, `patient_id`, `patient_first_name`, `patient_middle_name`, `patient_last_name`, `patient_birthday`, `patient_address`, `patient_contact_number`, `patient_sex`) VALUES
(8, 1045892, 'Emily', 'Rose', 'Chen', '1992-08-24 08:30:00', '4521 Oak Ave, Seattle, WA', '555-102-3948', 'Female'),
(9, 1045893, 'Marcus', 'James', 'Johnson', '1978-11-03 14:15:00', '89 Pine Road, Austin, TX', '555-839-2019', 'Male'),
(10, 1045894, 'Sophia', 'Marie', 'Martinez', '2005-02-15 09:00:00', '774 Sunset Blvd, Miami, FL', '555-448-9102', 'Female'),
(11, 1045895, 'David', 'Alan', 'Smith', '1965-06-30 11:45:00', '12 Willow Creek Dr, Denver, CO', '555-772-5561', 'Male'),
(12, 1045896, 'Aisha', 'Fatima', 'Patel', '1988-12-10 16:20:00', '903 Birch Lane, Boston, MA', '555-219-8473', 'Female'),
(13, 1045897, 'William', 'Thomas', 'Davis', '1955-04-22 07:10:00', '334 Cedar Court, Chicago, IL', '555-633-1120', 'Male'),
(14, 1045898, 'Olivia', 'Grace', 'Taylor', '1999-09-05 13:50:00', '551 Elm Street, Portland, OR', '555-901-4432', 'Female'),
(15, 1045899, 'Ethan', 'Daniel', 'Brown', '1982-01-14 10:05:00', '102 Birch St, Atlanta, GA', '555-321-7654', 'Male'),
(16, 1045900, 'Mia', 'Isabella', 'Garcia', '2010-07-22 18:30:00', '405 Maple Dr, Phoenix, AZ', '555-888-1234', 'Female'),
(17, 1045901, 'Alexander', NULL, 'Rodriguez', '1995-11-08 04:20:00', '789 Oak Ln, Dallas, TX', '555-555-0987', 'Male'),
(18, 1045902, 'Isabella', 'Rose', 'Wilson', '1970-03-30 22:15:00', '321 Pine Ct, San Diego, CA', '555-111-3333', 'Female'),
(19, 1045903, 'James', 'Michael', 'Anderson', '1960-09-12 13:45:00', '654 Elm Ave, Philadelphia, PA', '555-444-5555', 'Male'),
(20, 1045904, 'Charlotte', 'Elizabeth', 'Thomas', '2001-05-18 08:50:00', '987 Cedar Blvd, San Jose, CA', '555-222-6666', 'Female'),
(21, 1045905, 'Benjamin', 'David', 'Jackson', '1985-12-25 16:10:00', '135 Walnut St, Indianapolis, IN', '555-777-8888', 'Male'),
(22, 1045906, 'Amelia', 'Grace', 'White', '1990-04-02 09:30:00', '246 Cherry Rd, Jacksonville, FL', '555-999-0000', 'Female'),
(23, 1045907, 'Daniel', 'Joseph', 'Harris', '1975-08-19 11:25:00', '369 Spruce Ln, San Francisco, CA', '555-666-2222', 'Male'),
(24, 1045908, 'Harper', NULL, 'Martin', '2015-10-05 14:00:00', '159 Ash Dr, Columbus, OH', '555-333-7777', 'Female'),
(25, 1045909, 'Lucas', 'Matthew', 'Clark', '1993-02-11 08:00:00', '111 Cedar St, Seattle, WA', '555-222-1111', 'Male'),
(26, 1045910, 'Evelyn', NULL, 'Rodriguez', '1987-05-14 14:20:00', '222 Oak Ave, Austin, TX', '555-333-2222', 'Female'),
(27, 1045911, 'Henry', 'James', 'Lee', '1954-10-22 09:15:00', '333 Pine Rd, Miami, FL', '555-444-3333', 'Male'),
(28, 1045912, 'Abigail', 'Marie', 'Walker', '2008-12-01 16:45:00', '444 Elm Dr, Denver, CO', '555-555-4444', 'Female'),
(29, 1045913, 'Sebastian', 'Alexander', 'Hall', '1979-07-08 11:30:00', '555 Maple Ln, Boston, MA', '555-666-5555', 'Male'),
(30, 1045914, 'Elizabeth', 'Grace', 'Allen', '1962-03-15 07:50:00', '666 Birch Ct, Chicago, IL', '555-777-6666', 'Female'),
(31, 1045915, 'Jack', 'Thomas', 'Young', '1998-09-28 13:10:00', '777 Walnut Street, Portland, OR', '555-888-7777', 'Male'),
(32, 1045916, 'Sofia', 'Isabella', 'Hernandez', '1984-01-05 10:25:00', '888 Cherry Ave, Atlanta, GA', '555-999-8888', 'Female'),
(33, 1045917, 'Wyatt', NULL, 'King', '2012-06-18 15:05:00', '999 Spruce Blvd, Phoenix, AZ', '555-000-9999', 'Male'),
(34, 1045918, 'Chloe', 'Elizabeth', 'Wright', '1991-11-30 08:40:00', '101 Ash Ln, Dallas, TX', '555-123-0001', 'Female'),
(35, 1045919, 'John', 'David', 'Lopez', '1968-04-12 12:00:00', '202 Cedar Ct, San Diego, CA', '555-234-0002', 'Male'),
(36, 1045920, 'Grace', 'Ann', 'Hill', '1973-08-25 18:15:00', '303 Oak Rd, Philadelphia, PA', '555-345-0003', 'Female'),
(37, 1045921, 'Owen', 'Michael', 'Scott', '2004-02-19 09:55:00', '404 Pine Ave, San Jose, CA', '555-456-0004', 'Male'),
(38, 1045922, 'Victoria', 'Rose', 'Green', '1989-10-07 14:35:00', '505 Elm Blvd, Indianapolis, IN', '555-567-0005', 'Female'),
(39, 1045923, 'Luke', 'Daniel', 'Adams', '1959-12-14 06:20:00', '606 Maple St, Jacksonville, FL', '555-678-0006', 'Male'),
(40, 1045924, 'Zoey', 'Nicole', 'Baker', '1996-05-03 11:10:00', '707 Birch Dr, San Francisco, CA', '555-789-0007', 'Female'),
(41, 1045925, 'Isaac', 'Joseph', 'Gonzalez', '1981-07-29 16:50:00', '808 Walnut Ct, Columbus, OH', '555-890-0008', 'Male'),
(42, 1045926, 'Penelope', NULL, 'Nelson', '2018-03-11 08:30:00', '909 Cherry Ln, Charlotte, NC', '555-901-0009', 'Female'),
(43, 1045927, 'Gabriel', 'Matthew', 'Carter', '1976-09-21 13:05:00', '112 Spruce Rd, Detroit, MI', '555-012-0010', 'Male'),
(44, 1045928, 'Riley', 'Jane', 'Mitchell', '1994-01-16 10:45:00', '223 Ash Ave, Memphis, TN', '555-123-0011', 'Female'),
(45, 1045929, 'Anthony', 'James', 'Perez', '1965-11-09 15:25:00', '334 Cedar Blvd, Seattle, WA', '555-234-0012', 'Male'),
(46, 1045930, 'Layla', 'Marie', 'Roberts', '2007-04-26 09:40:00', '445 Oak St, Boston, MA', '555-345-0013', 'Female'),
(47, 1045931, 'Dylan', 'Thomas', 'Turner', '1983-08-04 12:15:00', '556 Pine Ln, Austin, TX', '555-456-0014', 'Male'),
(48, 1045932, 'Lillian', 'Grace', 'Phillips', '1950-02-28 07:00:00', '667 Elm Ct, Denver, CO', '555-567-0015', 'Female'),
(49, 1045933, 'Lincoln', 'Alexander', 'Campbell', '1999-10-13 14:55:00', '778 Maple Rd, Miami, FL', '555-678-0016', 'Male'),
(50, 1045934, 'Natalie', NULL, 'Parker', '1971-06-06 17:30:00', '889 Birch Ave, Chicago, IL', '555-789-0017', 'Female'),
(51, 1045935, 'David', 'Minh', 'Nguyen', '1980-05-12 08:00:00', '123 Bamboo Way, San Jose, CA', '555-444-9999', 'Male'),
(52, 1045936, 'Mary', 'Thi', 'Nguyen', '1982-11-20 09:30:00', '123 Bamboo Way, San Jose, CA', '555-444-9999', 'Female'),
(53, 1045937, 'Kevin', 'Duc', 'Nguyen', '2010-03-15 14:15:00', '123 Bamboo Way, San Jose, CA', '555-444-9999', 'Male'),
(54, 1045938, 'Chloe', 'Mai', 'Nguyen', '2012-07-22 16:45:00', '123 Bamboo Way, San Jose, CA', '555-444-9999', 'Female'),
(55, 1045939, 'John', 'Robert', 'Smith', '1975-01-10 10:00:00', '742 Evergreen Terrace, Springfield, IL', '555-837-1293', 'Male'),
(56, 1045940, 'John', 'Edward', 'Smith', '1995-08-05 11:30:00', '990 Riverside Dr, New York, NY', '555-293-8475', 'Male'),
(57, 1045941, 'Sarah', 'Ann', 'Johnson', '1990-04-12 12:00:00', '412 Lakeview Blvd, Chicago, IL', '555-102-3948', 'Female'),
(58, 1045942, 'Sarah', 'Lynn', 'Williams', '1985-09-25 15:20:00', '88 Sunset Strip, Los Angeles, CA', '555-584-9302', 'Female'),
(59, 1045943, 'Emma', 'Grace', 'Miller', '2018-10-31 08:00:00', '5600 North Ave, Denver, CO', '555-948-2304', 'Female'),
(60, 1045944, 'Ethan', 'James', 'Miller', '2018-10-31 08:05:00', '5600 North Ave, Denver, CO', '555-948-2304', 'Male'),
(61, 1045945, 'Michael', 'Joseph', 'Brown', '1960-12-01 07:30:00', '1932 Heritage Ln, Boston, MA', '555-392-1049', 'Male'),
(62, 1045946, 'Michael', 'Joseph', 'Brown', '1988-02-14 18:10:00', '444 City Lofts, Boston, MA', '555-849-2039', 'Male'),
(63, 1045947, 'Jessica', 'Marie', 'Davis', '1992-09-28 07:45:00', '789 North Blvd, Chicago, IL', '555-555-6666', 'Female'),
(64, 1045948, 'Jessica', 'Lynn', 'Davis', '1992-09-28 21:10:00', '321 South Dr, Miami, FL', '555-777-8888', 'Female'),
(65, 1045949, 'Robert', 'Alan', 'Jones', '1985-04-12 09:15:00', '123 East St, New York, NY', '555-111-2222', 'Male'),
(66, 1045950, 'Robert', NULL, 'Jones', '1985-04-12 14:30:00', '456 West Ave, Los Angeles, CA', '555-333-4444', 'Male'),
(67, 1045951, 'Christopher', 'David', 'Garcia', '1978-11-03 10:00:00', '654 Elm St, Seattle, WA', '555-999-0000', 'Male'),
(68, 1045952, 'Amanda', 'Rose', 'Garcia', '1978-11-03 16:20:00', '987 Oak Ln, Austin, TX', '555-123-4567', 'Female'),
(69, 1045953, 'William', 'Thomas', 'Martinez', '2001-02-14 05:30:00', '246 Birch Rd, Denver, CO', '555-234-5678', 'Male'),
(70, 1045954, 'Sophia', 'Grace', 'Martinez', '2001-02-14 19:45:00', '135 Pine Ct, Atlanta, GA', '555-345-6789', 'Female'),
(71, 1045955, 'James', 'Robert', 'Williams', '1990-05-15 02:14:00', '101 Apple St, New York, NY', '555-101-1001', 'Male'),
(72, 1045956, 'James', 'Robert', 'Williams', '1990-05-15 08:30:00', '202 Orange Ave, Chicago, IL', '555-202-2002', 'Male'),
(73, 1045957, 'James', 'Robert', 'Williams', '1990-05-15 14:45:00', '303 Banana Blvd, Miami, FL', '555-303-3003', 'Male'),
(74, 1045958, 'James', 'Robert', 'Williams', '1990-05-15 19:20:00', '404 Grape Ln, Austin, TX', '555-404-4004', 'Male'),
(75, 1045959, 'James', 'Robert', 'Williams', '1990-05-15 23:55:00', '505 Melon Dr, Seattle, WA', '555-505-5005', 'Male'),
(76, 1045960, 'Sarah', 'Marie', 'Taylor', '1988-11-22 04:10:00', '11 A St, Boston, MA', '555-911-0001', 'Female'),
(77, 1045961, 'Sarah', 'Elizabeth', 'Taylor', '1988-11-22 09:15:00', '22 B St, Denver, CO', '555-922-0002', 'Female'),
(78, 1045962, 'Sarah', 'Ann', 'Taylor', '1988-11-22 13:40:00', '33 C St, Portland, OR', '555-933-0003', 'Female'),
(79, 1045963, 'Sarah', NULL, 'Taylor', '1988-11-22 16:05:00', '44 D St, Phoenix, AZ', '555-944-0004', 'Female'),
(80, 1045964, 'Sarah', 'Lynn', 'Taylor', '1988-11-22 21:50:00', '55 E St, Atlanta, GA', '555-955-0005', 'Female'),
(81, 1045965, 'Michael', 'David', 'Lee', '1975-07-04 01:25:00', '900 Red Way, Dallas, TX', '555-800-1111', 'Male'),
(82, 1045966, 'Jessica', 'Nicole', 'Lee', '1975-07-04 06:40:00', '800 Blue Cir, Detroit, MI', '555-800-2222', 'Female'),
(83, 1045967, 'David', 'Joseph', 'Lee', '1975-07-04 11:55:00', '700 Green Pl, Las Vegas, NV', '555-800-3333', 'Male'),
(84, 1045968, 'Emily', 'Rose', 'Lee', '1975-07-04 17:10:00', '600 Yellow Sq, Charlotte, NC', '555-800-4444', 'Female'),
(85, 1045969, 'Christopher', 'John', 'Lee', '1975-07-04 22:30:00', '500 Purple Pike, Orlando, FL', '555-800-5555', 'Male'),
(86, 1045970, 'Jay', NULL, 'Stellman', '2004-09-17 15:51:45', '17 Spruce Lane, Oshkosh, WI', '966-025-4296', 'Male');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_patient_records`
--
ALTER TABLE `tbl_patient_records`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `patient_birthday` (`patient_birthday`),
  ADD KEY `patient_last_name` (`patient_last_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_patient_records`
--
ALTER TABLE `tbl_patient_records`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;
--
-- Database: `laravel`
--
DROP DATABASE IF EXISTS `laravel`;
CREATE DATABASE IF NOT EXISTS `laravel` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `laravel`;
--
-- Database: `phpmyadmin`
--
DROP DATABASE IF EXISTS `phpmyadmin`;
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Table structure for table `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Table structure for table `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Table structure for table `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- Table structure for table `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Table structure for table `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Table structure for table `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Table structure for table `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- Dumping data for table `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"haa_med_center_pms_database\",\"table\":\"tbl_patient_records\"},{\"db\":\"pqs_database\",\"table\":\"tbl_users\"}]');

-- --------------------------------------------------------

--
-- Table structure for table `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Table structure for table `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

-- --------------------------------------------------------

--
-- Table structure for table `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Dumping data for table `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2026-11-07 09:42:36', '{\"Console\\/Mode\":\"collapse\"}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Table structure for table `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Indexes for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Indexes for table `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Indexes for table `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Indexes for table `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Indexes for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Indexes for table `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Indexes for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Indexes for table `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Indexes for table `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Indexes for table `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Indexes for table `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Indexes for table `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Indexes for table `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Database: `pqs_database`
--
DROP DATABASE IF EXISTS `pqs_database`;
CREATE DATABASE IF NOT EXISTS `pqs_database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `pqs_database`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_completed`
--

CREATE TABLE `tbl_completed` (
  `ID` int(10) NOT NULL,
  `queue_id` varchar(7) NOT NULL,
  `patient_id` varchar(20) NOT NULL,
  `patient_name` text NOT NULL,
  `marked_by` varchar(50) NOT NULL,
  `added_time_and_date` datetime NOT NULL,
  `marked_time_and_date` datetime NOT NULL,
  `department` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_completed`
--

INSERT INTO `tbl_completed` (`ID`, `queue_id`, `patient_id`, `patient_name`, `marked_by`, `added_time_and_date`, `marked_time_and_date`, `department`) VALUES
(1, 'HM-121', '126128', 'DREAMURR, TORIEL', 'user1', '2026-06-17 18:42:27', '2026-06-17 05:55:27', 'Hemodialysis'),
(2, 'HM-312', '126127', 'DREAMURR, ASGORE', 'user1', '2026-06-17 18:42:32', '2026-06-17 17:55:27', 'Hemodialysis'),
(3, 'HM-004', '123432', 'i will be marked completed', 'user1', '2026-06-18 12:00:48', '2026-06-18 19:03:32', 'Hemodialysis'),
(4, 'HM-005', '121213', 'i will disappear from the table', 'user1', '2026-06-18 13:26:45', '2026-06-18 19:27:49', 'Hemodialysis'),
(5, 'HM-006', '121312', 'removed + popup disappear', 'user1', '2026-06-18 13:30:51', '2026-06-18 19:38:22', 'Hemodialysis'),
(6, 'HM-007', '121211', 'disappear + success popup', 'user1', '2026-06-18 14:08:59', '2026-06-18 20:09:43', 'Hemodialysis'),
(7, 'HM-008', '1234322', 'last one please', 'user1', '2026-06-18 14:10:07', '2026-06-18 20:10:46', 'Hemodialysis'),
(8, 'HM-009', '635211', 'last last last', 'user1', '2026-06-18 14:11:20', '2026-06-18 20:11:55', 'Hemodialysis'),
(9, 'HM-010', '432343', 'record should disappear', 'user1', '2026-06-18 14:48:36', '2026-06-18 20:49:40', 'Hemodialysis'),
(10, 'HM-011', '438211', 'queue id should not disappear', 'user1', '2026-06-18 14:48:36', '2026-06-18 21:18:10', 'Hemodialysis'),
(11, 'HM-003', '438210', 'b', 'user1', '2026-06-18 15:19:23', '2026-06-18 21:20:08', 'Hemodialysis'),
(12, 'HM-008', '635212', 'a', 'user1', '2026-06-18 15:19:23', '2026-06-18 21:26:17', 'Hemodialysis'),
(13, 'HM-432', '123353', 'saaas', 'user1', '2026-06-18 15:27:25', '2026-06-18 21:27:53', 'Hemodialysis'),
(14, 'HM-008', '1234321', 'jaiisiahs', 'user1', '2026-06-18 15:27:25', '2026-06-18 21:28:05', 'Hemodialysis'),
(15, 'HM-002', '635212', 'i am second', 'user1', '2026-06-16 07:14:17', '2026-06-18 21:30:01', 'Hemodialysis'),
(16, 'HM-001', '1234321', 'i am first', 'user1', '2026-06-16 07:12:28', '2026-06-18 21:30:23', 'Hemodialysis'),
(17, 'HM-003', '438210', 'i am third', 'user1', '2026-06-16 07:14:17', '2026-06-18 21:30:26', 'Hemodialysis'),
(18, 'HT-001', '432341', 'i am first hearing test', 'user1', '2026-06-16 07:23:32', '2026-06-18 22:19:09', 'Hearing Test'),
(19, 'HM-001', '635213', 'hello', 'user1', '2026-06-18 16:21:21', '2026-06-18 22:57:02', 'Hemodialysis'),
(20, 'HM-001', '635213', 'hello', 'user1', '2026-06-18 16:21:21', '2026-06-18 22:57:47', 'Hemodialysis'),
(21, 'OPD-001', '744112', 'Michael Reyes', 'user1', '2026-06-18 08:10:00', '2026-06-18 23:10:49', 'OPD'),
(22, 'OPD-002', '744113', 'Anna Garcia', 'user1', '2026-06-18 08:12:00', '2026-06-22 08:01:33', 'OPD'),
(23, 'OPD-003', '744114', 'Pedro Bautista', 'user1', '2026-06-18 08:15:00', '2026-06-22 08:01:36', 'OPD'),
(24, 'OPD-004', '744115', 'Jose Villanueva', 'user1', '2026-06-18 08:35:00', '2026-06-22 08:10:11', 'OPD'),
(25, 'OPD-005', '744116', 'David Chua', 'user1', '2026-06-18 08:45:00', '2026-06-22 08:15:16', 'OPD'),
(26, 'OPD-006', '744117', 'Gloria Sy', 'user1', '2026-06-18 09:00:00', '2026-06-22 08:15:54', 'OPD'),
(27, 'OPD-007', '744118', 'Anita Perez', 'user1', '2026-06-18 09:10:00', '2026-06-22 08:15:59', 'OPD'),
(28, 'OPD-008', '744119', 'Ramon Valdez', 'user1', '2026-06-18 09:25:00', '2026-06-22 08:18:09', 'OPD'),
(29, 'ER-001', '999111', 'Rosa Martinez', 'user1', '2026-06-18 08:40:00', '2026-06-22 08:20:47', 'ER'),
(30, 'ER-002', '999112', 'Leo Roxas', 'user1', '2026-06-18 09:05:00', '2026-06-22 08:36:20', 'ER'),
(31, 'ER-003', '999113', 'Theresa Cruz', 'user1', '2026-06-18 09:30:00', '2026-06-22 08:36:39', 'ER'),
(32, 'ER-001', '999200', 'George Santos', 'user1', '2026-06-18 08:25:00', '2026-06-22 08:38:45', 'ER'),
(33, 'ER-002', '999201', 'Hannah Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 08:39:05', 'ER'),
(34, 'ER-001', '999200', 'George Santos', 'user1', '2026-06-18 08:25:00', '2026-06-22 08:39:47', 'ER'),
(35, 'ER-002', '999201', 'Hannah Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 08:40:07', 'ER'),
(36, 'ER-001', '999200', 'George Santos', 'user1', '2026-06-18 08:25:00', '2026-06-22 08:42:19', 'ER'),
(37, 'ER-002', '999201', 'Hannah Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 08:43:28', 'ER'),
(38, 'ER-001', '999200', 'George Santos', 'user1', '2026-06-18 08:25:00', '2026-06-22 08:43:52', 'ER'),
(39, 'ER-002', '999201', 'Hannah Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 08:44:25', 'ER'),
(40, 'ER-001', '999200', 'George Santos', 'user1', '2026-06-18 08:25:00', '2026-06-22 08:44:37', 'ER'),
(41, 'ER-002', '999201', 'Hannah Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 08:45:17', 'ER'),
(42, 'ER-001', '999200', 'George Santos', 'user1', '2026-06-18 08:25:00', '2026-06-22 08:46:19', 'ER'),
(43, 'ER-002', '999201', 'Hannah Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 08:46:57', 'ER'),
(44, 'ER-001', '999200', 'George Santos', 'user1', '2026-06-18 08:25:00', '2026-06-22 08:48:10', 'ER'),
(45, 'ER-002', '999201', 'Hannah Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 08:50:22', 'ER'),
(46, 'ER-001', '999200', 'George Santos', 'user1', '2026-06-18 08:25:00', '2026-06-22 08:51:06', 'ER'),
(47, 'HM-001', '635213', 'Juan Dela Cruz', 'user1', '2026-06-18 08:00:00', '2026-06-22 09:20:16', 'Hemodialysis'),
(48, 'HM-001', '635300', 'Alice Reyes', 'user1', '2026-06-18 08:00:00', '2026-06-22 09:20:19', 'Hemodialysis'),
(49, 'HM-001', '635300', 'Alice Reyes', 'user1', '2026-06-18 08:00:00', '2026-06-22 09:20:20', 'Hemodialysis'),
(50, 'HM-001', '635300', 'Alice Reyes', 'user1', '2026-06-18 08:00:00', '2026-06-22 09:20:23', 'Hemodialysis'),
(51, 'HM-002', '635214', 'Maria Santos', 'user1', '2026-06-18 08:05:00', '2026-06-22 09:21:51', 'Hemodialysis'),
(52, 'HM-002', '635301', 'Bob Tan', 'user1', '2026-06-18 08:05:00', '2026-06-22 09:22:36', 'Hemodialysis'),
(53, 'HM-002', '635301', 'Bob Tan', 'user1', '2026-06-18 08:05:00', '2026-06-22 09:22:39', 'Hemodialysis'),
(54, 'HM-002', '635301', 'Bob Tan', 'user1', '2026-06-18 08:05:00', '2026-06-22 09:22:42', 'Hemodialysis'),
(55, 'HM-003', '635215', 'Susan Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 09:24:47', 'Hemodialysis'),
(56, 'HM-004', '635216', 'Mark Fernandez', 'user1', '2026-06-18 08:55:00', '2026-06-22 09:25:02', 'Hemodialysis'),
(57, 'HM-005', '635217', 'Carlos Mendoza', 'user1', '2026-06-18 09:15:00', '2026-06-22 09:26:11', 'Hemodialysis'),
(58, 'OPD-001', '744200', 'Charlie Cruz', 'user1', '2026-06-18 08:10:00', '2026-06-22 09:27:15', 'OPD'),
(59, 'OPD-001', '744200', 'Charlie Cruz', 'user1', '2026-06-18 08:10:00', '2026-06-22 09:29:14', 'OPD'),
(60, 'OPD-002', '744201', 'Diana Lopez', 'user1', '2026-06-18 08:12:00', '2026-06-22 09:29:33', 'OPD'),
(61, 'OPD-002', '744201', 'Diana Lopez', 'user1', '2026-06-18 08:12:00', '2026-06-22 09:30:14', 'OPD'),
(62, 'RAD-001', '811234', 'Elena Castro', 'user1', '2026-06-18 08:20:00', '2026-06-22 09:30:56', 'Radiology'),
(63, 'RAD-001', '811300', 'Ethan Chua', 'user1', '2026-06-18 08:15:00', '2026-06-22 09:31:02', 'Radiology'),
(64, 'RAD-001', '811300', 'Ethan Chua', 'user1', '2026-06-18 08:15:00', '2026-06-22 09:31:10', 'Radiology'),
(65, 'RAD-002', '811235', 'Ricardo Gomez', 'user1', '2026-06-18 08:25:00', '2026-06-22 09:31:16', 'Radiology'),
(66, 'RAD-002', '811301', 'Fiona Garcia', 'user1', '2026-06-18 08:20:00', '2026-06-22 09:31:22', 'Radiology'),
(67, 'RAD-002', '811301', 'Fiona Garcia', 'user1', '2026-06-18 08:20:00', '2026-06-22 09:31:23', 'Radiology'),
(68, 'RAD-003', '811236', 'Karen Ocampo', 'user1', '2026-06-18 08:50:00', '2026-06-22 09:31:34', 'Radiology'),
(69, 'RAD-004', '811237', 'Liza Tolentino', 'user1', '2026-06-18 09:20:00', '2026-06-22 09:31:38', 'Radiology'),
(70, 'ER-002', '999201', 'Hannah Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 09:31:53', 'ER'),
(71, 'ER-002', '999201', 'Hannah Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 09:32:15', 'ER'),
(72, 'ER-001', '999200', 'George Santos', 'user1', '2026-06-18 08:25:00', '2026-06-22 09:33:33', 'ER'),
(73, 'ER-001', '999111', 'Rosa Martinez', 'user1', '2026-06-18 08:40:00', '2026-06-22 09:35:41', 'ER'),
(74, 'ER-002', '999112', 'Leo Roxas', 'user1', '2026-06-18 09:05:00', '2026-06-22 09:37:13', 'ER'),
(75, 'ER-003', '999113', 'Theresa Cruz', 'user1', '2026-06-18 09:30:00', '2026-06-22 09:39:29', 'ER'),
(76, 'OPD-001', '744112', 'Michael Reyes', 'user1', '2026-06-18 08:10:00', '2026-06-22 09:39:58', 'OPD'),
(77, 'OPD-002', '744113', 'Anna Garcia', 'user1', '2026-06-18 08:12:00', '2026-06-22 09:42:49', 'OPD'),
(78, 'OPD-003', '744114', 'Pedro Bautista', 'user1', '2026-06-18 08:15:00', '2026-06-22 09:44:01', 'OPD'),
(79, 'OPD-004', '744115', 'Jose Villanueva', 'user1', '2026-06-18 08:35:00', '2026-06-22 09:45:01', 'OPD'),
(80, 'OPD-005', '744116', 'David Chua', 'user1', '2026-06-18 08:45:00', '2026-06-22 09:45:03', 'OPD'),
(81, 'OPD-006', '744117', 'Gloria Sy', 'user1', '2026-06-18 09:00:00', '2026-06-22 09:45:16', 'OPD'),
(82, 'OPD-007', '744118', 'Anita Perez', 'user1', '2026-06-18 09:10:00', '2026-06-22 09:45:19', 'OPD'),
(83, 'OPD-008', '744119', 'Ramon Valdez', 'user1', '2026-06-18 09:25:00', '2026-06-22 09:45:22', 'OPD'),
(84, 'RAD-001', '811234', 'Elena Castro', 'user1', '2026-06-18 08:20:00', '2026-06-22 09:47:45', 'Radiology'),
(85, 'RAD-002', '811235', 'Ricardo Gomez', 'user1', '2026-06-18 08:25:00', '2026-06-22 09:47:56', 'Radiology'),
(86, 'RAD-004', '811237', 'Liza Tolentino', 'user1', '2026-06-18 09:20:00', '2026-06-22 09:48:00', 'Radiology'),
(87, 'RAD-003', '811236', 'Karen Ocampo', 'user1', '2026-06-18 08:50:00', '2026-06-22 09:48:11', 'Radiology'),
(88, 'HM-001', '635213', 'Juan Dela Cruz', 'user1', '2026-06-18 08:00:00', '2026-06-22 09:51:54', 'Hemodialysis'),
(89, 'HM-002', '635214', 'Maria Santos', 'user1', '2026-06-18 08:05:00', '2026-06-22 09:51:57', 'Hemodialysis'),
(90, 'HM-003', '635215', 'Susan Lim', 'user1', '2026-06-18 08:30:00', '2026-06-22 09:51:59', 'Hemodialysis'),
(91, 'HM-004', '635216', 'Mark Fernandez', 'user1', '2026-06-18 08:55:00', '2026-06-22 09:52:01', 'Hemodialysis'),
(92, 'HM-005', '635217', 'Carlos Mendoza', 'user1', '2026-06-18 09:15:00', '2026-06-22 09:55:52', 'Hemodialysis'),
(93, 'HM-001', '635213', 'Juan Dela Cruz', 'user1', '2026-06-18 08:00:00', '2026-06-22 10:01:52', 'Hemodialysis'),
(94, 'HM-004', '635216', 'Mark Fernandez', 'user1', '2026-06-18 08:55:00', '2026-06-22 13:40:38', 'Hemodialysis'),
(95, 'OPD-001', '744112', 'Michael Reyes', 'user1', '2026-06-18 08:10:00', '2026-06-22 13:40:54', 'OPD'),
(96, 'OPD-002', '744113', 'Anna Garcia', 'user1', '2026-06-18 08:12:00', '2026-06-22 13:40:59', 'OPD'),
(97, 'OPD-008', '744119', 'Ramon Valdez', 'user1', '2026-06-18 09:25:00', '2026-06-22 13:49:44', 'OPD'),
(98, 'RAD-004', '811237', 'Liza Tolentino', 'user1', '2026-06-18 09:20:00', '2026-06-22 14:10:32', 'Radiology'),
(99, 'ER-001', '999111', 'Rosa Martinez', 'jaystellman', '2026-06-18 08:40:00', '2026-06-22 16:16:15', 'ER'),
(100, 'ER-001', '999111', 'Rosa Martinez', 'jaystellman', '2026-06-18 08:40:00', '2026-06-24 08:35:59', 'ER'),
(101, 'OPD-001', '744112', 'Michael Reyes', 'jaystellman', '2026-06-18 08:10:00', '2026-06-24 08:47:30', 'OPD'),
(102, 'OPD-002', '744113', 'Anna Garcia', 'jaystellman', '2026-06-18 08:12:00', '2026-06-24 08:48:47', 'OPD'),
(103, 'OPD-004', '744115', 'Jose Villanueva', 'jaystellman', '2026-06-18 08:35:00', '2026-06-24 08:49:08', 'OPD'),
(104, 'OPD-006', '744117', 'Gloria Sy', 'jaystellman', '2026-06-18 09:00:00', '2026-06-24 09:12:57', 'OPD'),
(105, 'OPD-007', '744118', 'Anita Perez', 'jaystellman', '2026-06-18 09:10:00', '2026-06-24 10:35:23', 'OPD'),
(106, 'OPD-007', '1045893', 'Johnson, Marcus James', 'jaystellman', '2026-06-25 14:37:00', '2026-06-25 15:06:57', 'OPD'),
(107, 'CM-001', '1045947', 'Davis, Jessica Marie', 'jaystellman', '2026-06-25 15:09:00', '2026-06-25 15:17:50', 'Chemotherapy'),
(108, 'CM-001', '1045965', 'Lee, Michael David', 'jaystellman', '2026-06-25 15:18:29', '2026-06-25 15:33:11', 'Chemotherapy'),
(109, 'CM-001', '1045913', 'Hall, Sebastian Alexander', 'jaystellman', '2026-06-25 15:33:29', '2026-06-25 16:07:23', 'Chemotherapy'),
(110, 'CM-002', '1045938', 'Nguyen, Chloe Mai', 'jaystellman', '2026-06-25 15:17:25', '2026-06-25 16:15:15', 'Chemotherapy'),
(111, 'OPD-008', '1045894', 'Martinez, Sophia Marie', 'jaystellman', '2026-06-25 14:42:01', '2026-06-25 16:35:04', 'OPD'),
(112, 'OPD-009', '1045895', 'Smith, David Alan', 'jaystellman', '2026-06-25 14:43:17', '2026-06-25 16:35:10', 'OPD'),
(113, 'OPD-003', '1045893', 'Johnson, Marcus James', 'jaystellman', '2026-06-27 11:21:20', '2026-06-27 11:25:53', 'OPD'),
(114, 'OPD-004', '1045894', 'Martinez, Sophia Marie', 'jaystellman', '2026-06-27 11:25:35', '2026-06-27 13:27:33', 'OPD'),
(115, 'HM-002', '1045903', 'Anderson, James Michael', 'jaystellman', '2026-06-27 15:40:27', '2026-06-27 15:50:03', 'Hemodialysis'),
(116, 'CM-002', '1045896', 'Patel, Aisha Fatima', 'jaystellman', '2026-06-30 09:27:32', '2026-06-30 09:34:32', 'Chemotherapy'),
(117, 'CM-003', '1045895', 'Smith, David Alan', 'jaystellman', '2026-06-30 09:37:51', '2026-06-30 09:49:00', 'Chemotherapy'),
(118, 'CM-004', '1045896', 'Patel, Aisha Fatima', 'jaystellman', '2026-06-30 09:49:31', '2026-06-30 09:56:10', 'Chemotherapy'),
(119, 'CM-005', '1045898', 'Taylor, Olivia Grace', 'jaystellman', '2026-06-30 09:56:22', '2026-06-30 09:58:57', 'Chemotherapy'),
(120, 'CM-008', '1045896', 'Patel, Aisha Fatima', 'jaystellman', '2026-06-30 09:59:35', '2026-06-30 09:59:40', 'Chemotherapy'),
(121, 'CM-009', '1045896', 'Patel, Aisha Fatima', 'jaystellman', '2026-06-30 09:59:47', '2026-06-30 09:59:55', 'Chemotherapy'),
(122, 'RD-002', '1045901', 'Rodriguez, Alexander', 'jaystellman', '2026-06-30 14:19:44', '2026-06-30 21:43:46', 'Radiology'),
(123, 'RD-001', '1045900', 'Garcia, Mia Isabella', 'jaystellman', '2026-06-30 13:16:23', '2026-06-30 21:44:46', 'Radiology'),
(124, 'RD-003', '1045902', 'Wilson, Isabella Rose', 'jaystellman', '2026-06-30 16:39:45', '2026-06-30 21:45:20', 'Radiology'),
(125, 'RD-001', '1045965', 'Lee, Michael David', 'jaystellman', '2026-07-01 08:12:03', '2026-07-01 09:52:37', 'Radiology'),
(126, 'RD-002', '1045966', 'Lee, Jessica Nicole', 'jaystellman', '2026-07-01 08:32:26', '2026-07-01 09:58:09', 'Radiology'),
(127, 'RD-003', '1045967', 'Lee, David Joseph', 'jaystellman', '2026-07-01 08:32:39', '2026-07-01 09:59:08', 'Radiology'),
(128, 'RD-004', '1045968', 'Lee, Emily Rose', 'jaystellman', '2026-07-01 08:32:46', '2026-07-01 10:01:18', 'Radiology'),
(129, 'RD-006', '1045970', 'Stellman, Jay', 'jaystellman', '2026-07-01 08:33:28', '2026-07-01 10:03:39', 'Radiology'),
(130, 'RD-007', '1045964', 'Taylor, Sarah Lynn', 'jaystellman', '2026-07-01 08:33:47', '2026-07-01 10:04:07', 'Radiology'),
(131, 'RD-008', '1045963', 'Taylor, Sarah', 'jaystellman', '2026-07-01 08:33:54', '2026-07-01 10:33:28', 'Radiology'),
(132, 'RD-009', '1045962', 'Taylor, Sarah Ann', 'jaystellman', '2026-07-01 08:34:46', '2026-07-01 10:34:38', 'Radiology'),
(133, 'RD-010', '1045961', 'Taylor, Sarah Elizabeth', 'jaystellman', '2026-07-01 08:35:00', '2026-07-01 10:36:56', 'Radiology'),
(134, 'RD-011', '1045960', 'Taylor, Sarah Marie', 'jaystellman', '2026-07-01 08:35:38', '2026-07-01 10:40:19', 'Radiology'),
(135, 'HM-001', '1045970', 'Stellman, Jay', 'jaystellman', '2026-07-01 09:33:19', '2026-07-01 10:41:10', 'Hemodialysis'),
(136, 'RD-005', '1045969', 'Lee, Christopher John', 'jaystellman', '2026-07-01 08:33:11', '2026-07-01 10:41:15', 'Radiology'),
(137, 'HM-002', '1045969', 'Lee, Christopher John', 'jaystellman', '2026-07-01 10:41:05', '2026-07-01 10:42:30', 'Hemodialysis'),
(138, 'RD-012', '1045970', 'Stellman, Jay', 'jaystellman', '2026-07-01 10:40:59', '2026-07-01 10:42:33', 'Radiology'),
(139, 'CM-001', '1045970', 'Stellman, Jay', 'jaystellman', '2026-07-01 10:47:05', '2026-07-01 12:57:09', 'Chemotherapy'),
(140, 'CM-004', '1045952', 'Garcia, Amanda Rose', 'jaystellman', '2026-07-01 12:52:24', '2026-07-01 12:58:12', 'Chemotherapy'),
(141, 'CM-005', '1045953', 'Martinez, William Thomas', 'jaystellman', '2026-07-01 12:52:34', '2026-07-01 12:58:18', 'Chemotherapy'),
(142, 'CM-006', '1045954', 'Martinez, Sophia Grace', 'jaystellman', '2026-07-01 12:53:05', '2026-07-01 12:58:28', 'Chemotherapy'),
(143, 'CM-008', '1045956', 'Williams, James Robert', 'jaystellman', '2026-07-01 12:58:59', '2026-07-01 12:59:35', 'Chemotherapy'),
(144, 'CM-009', '1045957', 'Williams, James Robert', 'jaystellman', '2026-07-01 12:59:05', '2026-07-01 13:00:45', 'Chemotherapy'),
(145, 'CM-010', '1045958', 'Williams, James Robert', 'jaystellman', '2026-07-01 12:59:09', '2026-07-01 13:01:32', 'Chemotherapy'),
(146, 'CM-012', '1045960', 'Taylor, Sarah Marie', 'jaystellman', '2026-07-01 12:59:25', '2026-07-01 13:02:10', 'Chemotherapy'),
(147, 'CM-013', '1045961', 'Taylor, Sarah Elizabeth', 'jaystellman', '2026-07-01 12:59:29', '2026-07-01 13:13:33', 'Chemotherapy'),
(148, 'CM-014', '1045962', 'Taylor, Sarah Ann', 'jaystellman', '2026-07-01 13:02:50', '2026-07-01 13:18:02', 'Chemotherapy'),
(149, 'CM-016', '1045964', 'Taylor, Sarah Lynn', 'jaystellman', '2026-07-01 13:06:25', '2026-07-01 13:22:53', 'Chemotherapy'),
(150, 'CM-019', '1045962', 'Taylor, Sarah Ann', 'jaystellman', '2026-07-01 13:25:47', '2026-07-01 13:26:02', 'Chemotherapy'),
(151, 'CM-018', '1045961', 'Taylor, Sarah Elizabeth', 'jaystellman', '2026-07-01 13:25:41', '2026-07-01 13:26:40', 'Chemotherapy'),
(152, 'CM-022', '1045963', 'Taylor, Sarah', 'jaystellman', '2026-07-01 13:26:27', '2026-07-01 13:26:51', 'Chemotherapy'),
(153, 'CM-024', '1045960', 'Taylor, Sarah Marie', 'jaystellman', '2026-07-01 13:27:28', '2026-07-01 13:27:45', 'Chemotherapy'),
(154, 'CM-028', '1045958', 'Williams, James Robert', 'jaystellman', '2026-07-01 13:30:23', '2026-07-01 13:35:05', 'Chemotherapy'),
(155, 'CM-029', '1045957', 'Williams, James Robert', 'jaystellman', '2026-07-01 13:30:31', '2026-07-01 13:35:16', 'Chemotherapy'),
(156, 'CM-030', '1045956', 'Williams, James Robert', 'jaystellman', '2026-07-01 13:30:39', '2026-07-01 13:35:22', 'Chemotherapy'),
(157, 'CM-031', '1045955', 'Williams, James Robert', 'jaystellman', '2026-07-01 13:30:45', '2026-07-01 13:36:04', 'Chemotherapy'),
(158, 'CM-027', '1045959', 'Williams, James Robert', 'jaystellman', '2026-07-01 13:30:17', '2026-07-01 13:36:16', 'Chemotherapy'),
(159, 'CM-032', '1045954', 'Martinez, Sophia Grace', 'jaystellman', '2026-07-01 13:30:52', '2026-07-01 13:36:37', 'Chemotherapy'),
(160, 'CM-034', '1045952', 'Garcia, Amanda Rose', 'jaystellman', '2026-07-01 13:31:14', '2026-07-01 13:37:56', 'Chemotherapy'),
(161, 'CM-026', '1045960', 'Taylor, Sarah Marie', 'jaystellman', '2026-07-01 13:30:04', '2026-07-01 13:39:51', 'Chemotherapy'),
(162, 'CM-025', '1045961', 'Taylor, Sarah Elizabeth', 'jaystellman', '2026-07-01 13:27:40', '2026-07-01 13:40:08', 'Chemotherapy'),
(163, 'CM-023', '1045964', 'Taylor, Sarah Lynn', 'jaystellman', '2026-07-01 13:26:32', '2026-07-01 13:41:06', 'Chemotherapy'),
(164, 'CM-033', '1045953', 'Martinez, William Thomas', 'jaystellman', '2026-07-01 13:31:01', '2026-07-01 13:42:29', 'Chemotherapy'),
(165, 'CM-020', '1045960', 'Taylor, Sarah Marie', 'jaystellman', '2026-07-01 13:26:15', '2026-07-01 13:47:59', 'Chemotherapy'),
(166, 'CM-035', '1045951', 'Garcia, Christopher David', 'jaystellman', '2026-07-01 13:31:21', '2026-07-01 13:48:05', 'Chemotherapy'),
(167, 'CM-021', '1045962', 'Taylor, Sarah Ann', 'jaystellman', '2026-07-01 13:26:21', '2026-07-01 13:48:08', 'Chemotherapy'),
(168, 'CM-015', '1045963', 'Taylor, Sarah', 'jaystellman', '2026-07-01 13:04:21', '2026-07-01 13:49:17', 'Chemotherapy'),
(169, 'CM-017', '1045960', 'Taylor, Sarah Marie', 'jaystellman', '2026-07-01 13:11:42', '2026-07-01 13:57:04', 'Chemotherapy'),
(170, 'CM-011', '1045959', 'Williams, James Robert', 'jaystellman', '2026-07-01 12:59:14', '2026-07-01 13:57:08', 'Chemotherapy'),
(171, 'CM-007', '1045955', 'Williams, James Robert', 'jaystellman', '2026-07-01 12:53:52', '2026-07-01 13:57:29', 'Chemotherapy'),
(172, 'CM-002', '1045950', 'Jones, Robert', 'jaystellman', '2026-07-01 11:48:12', '2026-07-01 13:58:27', 'Chemotherapy'),
(173, 'CM-036', '1045951', 'Garcia, Christopher David', 'jaystellman', '2026-07-01 13:57:50', '2026-07-01 13:58:53', 'Chemotherapy'),
(174, 'CM-037', '1045952', 'Garcia, Amanda Rose', 'jaystellman', '2026-07-01 13:57:55', '2026-07-01 13:59:52', 'Chemotherapy'),
(175, 'CM-038', '1045953', 'Martinez, William Thomas', 'jaystellman', '2026-07-01 13:58:00', '2026-07-01 14:08:40', 'Chemotherapy'),
(176, 'CM-040', '1045955', 'Williams, James Robert', 'jaystellman', '2026-07-01 13:58:11', '2026-07-01 14:08:54', 'Chemotherapy'),
(177, 'CM-041', '1045956', 'Williams, James Robert', 'jaystellman', '2026-07-01 13:58:16', '2026-07-01 14:08:59', 'Chemotherapy'),
(178, 'CM-042', '1045957', 'Williams, James Robert', 'jaystellman', '2026-07-01 13:58:21', '2026-07-01 14:09:18', 'Chemotherapy'),
(179, 'CM-039', '1045954', 'Martinez, Sophia Grace', 'jaystellman', '2026-07-01 13:58:06', '2026-07-01 14:09:50', 'Chemotherapy'),
(180, 'CM-003', '1045951', 'Garcia, Christopher David', 'jaystellman', '2026-07-01 11:48:26', '2026-07-01 14:10:25', 'Chemotherapy'),
(181, 'CM-043', '1045952', 'Garcia, Amanda Rose', 'jaystellman', '2026-07-01 14:10:00', '2026-07-01 14:10:28', 'Chemotherapy'),
(182, 'CM-044', '1045953', 'Martinez, William Thomas', 'jaystellman', '2026-07-01 14:10:08', '2026-07-01 14:19:30', 'Chemotherapy'),
(183, 'CM-045', '1045955', 'Williams, James Robert', 'jaystellman', '2026-07-01 14:10:13', '2026-07-01 14:19:33', 'Chemotherapy'),
(184, 'CM-047', '1045956', 'Williams, James Robert', 'jaystellman', '2026-07-01 14:20:15', '2026-07-01 14:20:19', 'Chemotherapy'),
(185, 'CM-048', '1045956', 'Williams, James Robert', 'jaystellman', '2026-07-01 14:20:35', '2026-07-01 14:20:39', 'Chemotherapy'),
(186, 'CM-052', '1045970', 'Stellman, Jay', 'jaystellman', '2026-07-01 14:24:23', '2026-07-01 14:24:27', 'Chemotherapy'),
(187, 'HM-004', '1045969', 'Lee, Christopher John', 'jaystellman', '2026-07-01 10:45:09', '2026-07-01 15:09:41', 'Hemodialysis'),
(188, 'CM-008', '1045902', 'Wilson, Isabella Rose', 'jaystellman', '2026-07-02 08:37:15', '2026-07-02 09:12:03', 'Chemotherapy'),
(189, 'CM-001', '1045965', 'Lee, Michael David', 'jaystellman', '2026-07-03 11:22:03', '2026-07-03 11:22:53', 'Chemotherapy'),
(190, 'CM-003', '1045965', 'Lee, Michael David', 'jaystellman', '2026-07-03 11:39:25', '2026-07-03 12:19:27', 'Chemotherapy'),
(191, 'CM-002', '1045893', 'Johnson, Marcus James', 'jaystellman', '2026-07-20 10:16:58', '2026-07-20 10:19:11', 'Chemotherapy'),
(192, 'CM-004', '1045965', 'Lee, Michael David', 'jaystellman', '2026-07-20 10:58:20', '2026-07-20 11:01:59', 'Chemotherapy'),
(193, 'CM-005', '1045965', 'Lee, Michael David', 'jaystellman', '2026-07-20 11:05:23', '2026-07-20 11:09:11', 'Chemotherapy'),
(194, 'CM-001', '1045965', 'Lee, Michael David', 'jaystellman', '2026-07-21 13:50:52', '2026-07-21 13:52:31', 'Chemotherapy'),
(195, 'CM-017', '1045959', 'Williams, James Robert', 'jaystellman', '2026-07-21 15:02:48', '2026-07-21 15:44:36', 'Chemotherapy'),
(196, 'CM-004', '1045967', 'Lee, David Joseph', 'jaystellman', '2026-07-21 13:53:22', '2026-07-21 15:45:11', 'Chemotherapy'),
(197, 'CM-005', '1045968', 'Lee, Emily Rose', 'jaystellman', '2026-07-21 13:53:28', '2026-07-21 15:47:28', 'Chemotherapy'),
(198, 'CM-003', '1045966', 'Lee, Jessica Nicole', 'jaystellman', '2026-07-21 13:53:10', '2026-07-21 15:59:23', 'Chemotherapy'),
(199, 'CM-006', '1045960', 'Taylor, Sarah Marie', 'jaystellman', '2026-07-21 13:53:35', '2026-07-21 15:59:55', 'Chemotherapy'),
(200, 'CM-007', '1045969', 'Lee, Christopher John', 'jaystellman', '2026-07-21 14:03:31', '2026-07-21 16:00:33', 'Chemotherapy'),
(201, 'CM-008', '1045950', 'Jones, Robert', 'jaystellman', '2026-07-21 14:03:38', '2026-07-21 16:02:42', 'Chemotherapy'),
(202, 'CM-009', '1045951', 'Garcia, Christopher David', 'jaystellman', '2026-07-21 14:03:44', '2026-07-21 16:04:42', 'Chemotherapy'),
(203, 'CM-010', '1045952', 'Garcia, Amanda Rose', 'jaystellman', '2026-07-21 14:03:49', '2026-07-21 16:14:04', 'Chemotherapy'),
(204, 'CM-011', '1045953', 'Martinez, William Thomas', 'jaystellman', '2026-07-21 14:03:55', '2026-07-21 16:14:38', 'Chemotherapy'),
(205, 'CM-012', '1045954', 'Martinez, Sophia Grace', 'jaystellman', '2026-07-21 14:04:05', '2026-07-21 16:15:57', 'Chemotherapy'),
(206, 'CM-013', '1045955', 'Williams, James Robert', 'jaystellman', '2026-07-21 14:49:32', '2026-07-21 16:17:37', 'Chemotherapy'),
(207, 'CM-014', '1045956', 'Williams, James Robert', 'jaystellman', '2026-07-21 14:49:42', '2026-07-21 16:18:10', 'Chemotherapy'),
(208, 'CM-015', '1045957', 'Williams, James Robert', 'jaystellman', '2026-07-21 14:51:12', '2026-07-21 16:29:11', 'Chemotherapy'),
(209, 'CM-022', '1045965', 'Lee, Michael David', 'jaystellman', '2026-07-21 16:34:24', '2026-07-21 16:35:02', 'Chemotherapy'),
(210, 'CM-024', '1045967', 'Lee, David Joseph', 'jaystellman', '2026-07-21 16:34:40', '2026-07-21 16:37:47', 'Chemotherapy'),
(211, 'CM-026', '1045969', 'Lee, Christopher John', 'jaystellman', '2026-07-21 16:37:14', '2026-07-21 16:38:00', 'Chemotherapy'),
(212, 'CM-002', '1045966', 'Lee, Jessica Nicole', 'jaystellman', '2026-07-24 11:44:41', '2026-07-24 11:47:38', 'Chemotherapy'),
(213, 'HM-001', '1045965', 'Lee, Michael David', 'counter_admin', '2026-07-24 13:06:29', '2026-07-24 13:08:04', 'Hemodialysis'),
(214, 'CM-001', '1045965', 'Lee, Michael David', 'chemoadmin', '2026-07-27 08:40:11', '2026-07-27 13:06:11', 'Chemotherapy'),
(215, 'CM-001', '1045965', 'Lee, Michael David', 'chemoadmin', '2026-07-28 09:30:38', '2026-07-28 09:30:54', 'Chemotherapy'),
(216, 'CM-002', '1045969', 'Lee, Christopher John', 'chemoadmin', '2026-07-28 09:31:11', '2026-07-28 09:31:20', 'Chemotherapy'),
(217, 'CM-003', '1045966', 'Lee, Jessica Nicole', 'counter_staff', '2026-07-28 13:19:07', '2026-07-28 13:19:12', 'Chemotherapy'),
(218, 'CM-006', '1045965', 'Lee, Michael David', 'counter_admin', '2026-07-28 16:06:33', '2026-07-28 16:09:03', 'Chemotherapy'),
(219, 'CM-001', '1045965', 'Lee, Michael David', 'counter_admin', '2026-08-03 10:23:28', '2026-08-03 15:02:16', 'Chemotherapy'),
(220, 'CM-003', '1045968', 'Lee, Emily Rose', 'counter_admin', '2026-08-03 14:18:41', '2026-08-03 15:05:47', 'Chemotherapy'),
(221, 'CM-001', '1045965', 'Lee, Michael David', 'chemoadmin', '2026-08-16 00:11:41', '2026-08-16 00:39:01', 'Chemotherapy'),
(222, 'CM-002', '1045966', 'Lee, Jessica Nicole', 'counter_admin', '2026-08-16 00:12:57', '2026-08-16 00:40:01', 'Chemotherapy'),
(223, 'CM-005', '1045970', 'Stellman, Jay', 'chemoadmin', '2026-08-16 00:37:56', '2026-08-16 00:41:18', 'Chemotherapy'),
(224, 'CM-006', '1045970', 'Stellman, Jay', 'counter_staff', '2026-08-16 00:54:32', '2026-08-16 17:07:30', 'Chemotherapy'),
(225, 'CM-004', '1045968', 'Lee, Emily Rose', 'counter_staff', '2026-08-16 00:37:08', '2026-08-16 17:13:24', 'Chemotherapy'),
(226, 'CM-002', '1045970', 'Stellman, Jay', 'counter_staff', '2026-08-23 23:13:44', '2026-08-23 23:13:48', 'Chemotherapy');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_department_counters`
--

CREATE TABLE `tbl_department_counters` (
  `ID` int(11) NOT NULL,
  `department` varchar(50) NOT NULL,
  `last_recorded_date` date NOT NULL,
  `last_queue_id_num` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_department_counters`
--

INSERT INTO `tbl_department_counters` (`ID`, `department`, `last_recorded_date`, `last_queue_id_num`) VALUES
(1, 'OPD', '2026-07-21', 1),
(2, 'Chemotherapy', '2026-08-24', 1),
(3, 'Hemodialysis', '2026-08-03', 1),
(4, 'Hearing Test', '2026-08-03', 1),
(5, 'Radiology', '2026-07-21', 1),
(6, 'X-Ray', '2026-07-21', 1),
(7, 'OR', '2026-08-16', 2),
(8, 'ER', '2026-08-03', 1),
(9, 'Eye Center', '2026-08-16', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_last_page_updates`
--

CREATE TABLE `tbl_last_page_updates` (
  `ID` int(11) NOT NULL,
  `department` varchar(50) NOT NULL,
  `time_last_updated_queue` datetime DEFAULT NULL,
  `time_last_updated_completed` datetime DEFAULT NULL,
  `time_last_updated_removed` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_last_page_updates`
--

INSERT INTO `tbl_last_page_updates` (`ID`, `department`, `time_last_updated_queue`, `time_last_updated_completed`, `time_last_updated_removed`) VALUES
(1, 'Chemotherapy', '2026-08-24 12:58:03', '2026-08-23 23:13:48', '2026-08-24 12:58:03'),
(2, 'Counter', '2026-08-16 00:35:48', NULL, NULL),
(3, 'Eye Center', '2026-08-16 21:51:12', NULL, '2026-08-16 21:51:07'),
(4, 'Radiology', '2026-08-16 01:01:52', NULL, NULL),
(5, 'ER', '2026-08-16 01:02:16', NULL, NULL),
(6, 'OR', '2026-08-16 17:51:25', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_queues`
--

CREATE TABLE `tbl_queues` (
  `ID` int(10) NOT NULL,
  `place` int(11) DEFAULT NULL,
  `queue_id` varchar(7) NOT NULL,
  `patient_id` int(20) NOT NULL,
  `patient_name` text NOT NULL,
  `department` varchar(50) NOT NULL,
  `added_by` varchar(50) NOT NULL,
  `added_time_and_date` datetime NOT NULL,
  `called_time_and_date` datetime DEFAULT NULL,
  `is_calling` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_removed`
--

CREATE TABLE `tbl_removed` (
  `ID` int(10) NOT NULL,
  `queue_id` varchar(7) NOT NULL,
  `patient_id` varchar(20) NOT NULL,
  `patient_name` text NOT NULL,
  `department` varchar(50) NOT NULL,
  `reason` text NOT NULL,
  `removed_by` varchar(50) NOT NULL,
  `added_time_and_date` datetime NOT NULL,
  `removed_time_and_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_removed`
--

INSERT INTO `tbl_removed` (`ID`, `queue_id`, `patient_id`, `patient_name`, `department`, `reason`, `removed_by`, `added_time_and_date`, `removed_time_and_date`) VALUES
(1, 'HM-202', '121342', 'REAL, GUY T.', 'Hemodialysis', 'took by dr. who', 'user4', '2026-06-16 13:17:58', '2026-06-17 02:39:58'),
(2, 'HM-432', '242343', 'HOLIDAY, DECEMBER C.', 'Hemodialysis', 'followed the pointed tail', 'user1', '2026-06-16 13:17:49', '2026-06-17 02:39:58'),
(3, 'HM-345', '123454', 'AMONG, US S.', 'Hemodialysis', 'was a sussy baka', 'user1', '2026-06-16 13:18:01', '2026-06-17 03:04:20'),
(4, 'HM-312', '123353', 'KIRK, CHARLIE W.', 'Hemodialysis', 'we are him', 'user1', '2026-06-16 13:18:03', '2026-06-17 03:04:20'),
(5, 'HM-666', '666666', 'FOX, TOBIAS T.', 'Hemodialysis', 'too busy making chapter 5', 'user1', '2026-06-16 13:18:06', '2026-06-17 05:19:26'),
(6, 'HM-002', '635214', 'Maria Santos', 'Hemodialysis', 'Cutoff', 'user1', '2026-06-18 08:05:00', '2026-06-22 13:28:04'),
(7, 'HM-005', '635217', 'Carlos Mendoza', 'Hemodialysis', 'idk bruh', 'user1', '2026-06-18 09:15:00', '2026-06-22 13:28:28'),
(8, 'HM-003', '635215', 'Susan Lim', 'Hemodialysis', 'Cutoff', 'user1', '2026-06-18 08:30:00', '2026-06-22 13:39:23'),
(9, 'OPD-003', '744114', 'Pedro Bautista', 'OPD', 'IDK BRUH', 'user1', '2026-06-18 08:15:00', '2026-06-22 13:43:27'),
(10, 'OPD-004', '744115', 'Jose Villanueva', 'OPD', 'Did not appear after calling', 'user1', '2026-06-18 08:35:00', '2026-06-22 13:43:38'),
(11, 'OPD-005', '744116', 'David Chua', 'OPD', 'Wrong patient record selected', 'user1', '2026-06-18 08:45:00', '2026-06-22 13:43:46'),
(13, 'OPD-007', '744118', 'Anita Perez', 'OPD', 'anita max wynn', 'user1', '2026-06-18 09:10:00', '2026-06-22 13:44:07'),
(14, 'RAD-001', '811234', 'Elena Castro', 'Radiology', 'Cutoff', 'user1', '2026-06-18 08:20:00', '2026-06-22 13:56:51'),
(15, 'RAD-002', '811235', 'Ricardo Gomez', 'Radiology', 'among us', 'user1', '2026-06-18 08:25:00', '2026-06-22 13:58:34'),
(16, 'RAD-003', '811236', 'Karen Ocampo', 'Radiology', 'Did not appear after calling', 'user1', '2026-06-18 08:50:00', '2026-06-22 13:59:34'),
(17, 'ER-002', '999112', 'Leo Roxas', 'ER', 'Cutoff', 'user1', '2026-06-18 09:05:00', '2026-06-22 14:13:11'),
(18, 'ER-003', '999113', 'Theresa Cruz', 'ER', 'last record', 'jaystellman', '2026-06-18 09:30:00', '2026-06-22 16:16:30'),
(19, 'ER-001', '1234321', 'SUS, AMONG US', 'ER', 'inigo', 'jaystellman', '2026-06-23 11:58:37', '2026-06-23 18:01:50'),
(20, 'ER-002', '999112', 'Leo Roxas', 'ER', 'confirm testing', 'jaystellman', '2026-06-18 09:05:00', '2026-06-24 08:36:16'),
(24, 'OPD-008', '744119', 'Ramon Valdez', 'OPD', 'Cutoff', 'jaystellman', '2026-06-18 09:25:00', '2026-06-24 10:35:31'),
(25, 'OPD-005', '744116', 'David Chua', 'OPD', 'not real', 'jaystellman', '2026-06-18 08:45:00', '2026-06-25 14:48:46'),
(26, 'OPD-003', '744114', 'Pedro Bautista', 'OPD', 'not real', 'jaystellman', '2026-06-18 08:15:00', '2026-06-25 14:48:53'),
(29, 'CM-004', '1045965', 'Lee, Michael David', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-06-25 16:07:49', '2026-06-25 16:13:40'),
(31, 'CM-005', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-06-25 16:09:21', '2026-06-25 16:14:46'),
(33, 'OPD-001', '1045892', 'Chen, Emily Rose', 'OPD', 'testing', 'jaystellman', '2026-06-27 11:09:44', '2026-06-27 11:21:12'),
(34, 'OPD-002', '1045893', 'Johnson, Marcus James', 'OPD', 'Testing', 'jaystellman', '2026-06-27 11:21:01', '2026-06-27 11:21:17'),
(35, 'OPD-010', '1045896', 'Patel, Aisha Fatima', 'OPD', 'Did not appear after calling', 'jaystellman', '2026-06-27 13:18:27', '2026-06-27 13:19:59'),
(36, 'OPD-015', '1045899', 'Brown, Ethan Daniel', 'OPD', 'Did not appear after calling', 'jaystellman', '2026-06-27 13:27:05', '2026-06-27 13:27:37'),
(37, 'OPD-016', '1045899', 'Brown, Ethan Daniel', 'OPD', 'Did not appear after calling', 'jaystellman', '2026-06-27 13:27:40', '2026-06-27 13:28:28'),
(38, 'OPD-017', '1045899', 'Brown, Ethan Daniel', 'OPD', 'Did not appear after calling', 'jaystellman', '2026-06-27 13:28:31', '2026-06-27 13:29:56'),
(39, 'OPD-008', '1045892', 'Chen, Emily Rose', 'OPD', 'Did not appear after calling', 'jaystellman', '2026-06-27 13:16:14', '2026-06-27 13:31:57'),
(40, 'OPD-018', '1045899', 'Brown, Ethan Daniel', 'OPD', 'Did not appear after calling', 'jaystellman', '2026-06-27 13:30:02', '2026-06-27 13:32:03'),
(41, 'HM-001', '1045903', 'Anderson, James Michael', 'Hemodialysis', 'uh', 'jaystellman', '2026-06-27 15:36:51', '2026-06-27 15:39:12'),
(42, 'HM-001', '635213', 'Juan Dela Cruz', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-18 08:00:00', '2026-06-27 15:39:18'),
(43, 'HM-002', '635214', 'Maria Santos', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-18 08:05:00', '2026-06-27 15:39:18'),
(44, 'RAD-001', '811234', 'Elena Castro', 'Radiology', 'Auto-flushed: Day has passed', 'system', '2026-06-18 08:20:00', '2026-06-27 15:39:18'),
(45, 'RAD-002', '811235', 'Ricardo Gomez', 'Radiology', 'Auto-flushed: Day has passed', 'system', '2026-06-18 08:25:00', '2026-06-27 15:39:18'),
(46, 'HM-003', '635215', 'Susan Lim', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-18 08:30:00', '2026-06-27 15:39:18'),
(47, 'RAD-003', '811236', 'Karen Ocampo', 'Radiology', 'Auto-flushed: Day has passed', 'system', '2026-06-18 08:50:00', '2026-06-27 15:39:18'),
(48, 'HM-004', '635216', 'Mark Fernandez', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-18 08:55:00', '2026-06-27 15:39:18'),
(49, 'HM-005', '635217', 'Carlos Mendoza', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-18 09:15:00', '2026-06-27 15:39:18'),
(50, 'RAD-004', '811237', 'Liza Tolentino', 'Radiology', 'Auto-flushed: Day has passed', 'system', '2026-06-18 09:20:00', '2026-06-27 15:39:18'),
(51, 'ER-003', '999113', 'Theresa Cruz', 'ER', 'Auto-flushed: Day has passed', 'system', '2026-06-18 09:30:00', '2026-06-27 15:39:18'),
(52, 'OPD-006', '1045892', 'Chen, Emily Rose', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-18 09:00:00', '2026-06-27 15:39:18'),
(53, 'OPD-010', '1045896', 'Patel, Aisha Fatima', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-25 14:44:05', '2026-06-27 15:39:18'),
(54, 'OPD-011', '1045897', 'Davis, William Thomas', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-25 14:44:43', '2026-06-27 15:39:18'),
(55, 'OPD-012', '1045898', 'Taylor, Olivia Grace', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-25 14:45:58', '2026-06-27 15:39:18'),
(56, 'OPD-013', '1045899', 'Brown, Ethan Daniel', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-25 14:46:54', '2026-06-27 15:39:18'),
(57, 'OPD-014', '1045900', 'Garcia, Mia Isabella', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-25 14:50:06', '2026-06-27 15:39:18'),
(58, 'OPD-015', '1045901', 'Rodriguez, Alexander ', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-25 14:50:24', '2026-06-27 15:39:18'),
(59, 'OPD-016', '1045908', 'Martin, Harper', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-25 14:51:15', '2026-06-27 15:39:18'),
(60, 'OPD-017', '1045921', 'Scott, Owen Michael', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-25 14:52:03', '2026-06-27 15:39:18'),
(61, 'OPD-018', '1045966', 'Lee, Jessica Nicole', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-25 14:52:45', '2026-06-27 15:39:18'),
(62, 'CM-003', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-06-25 16:00:11', '2026-06-27 15:39:18'),
(63, 'CM-004', '1045964', 'Taylor, Sarah Lynn', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-06-25 16:16:54', '2026-06-27 15:39:18'),
(73, 'HM-002', '1045903', 'Anderson, James Michael', 'Hemodialysis', 'Wrong patient record selected', 'jaystellman', '2026-06-27 15:39:19', '2026-06-27 15:40:24'),
(74, 'CM-001', '1045892', 'Chen, Emily Rose', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-06-27 11:20:18', '2026-06-28 22:58:32'),
(75, 'CM-002', '1045893', 'Johnson, Marcus James', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-06-27 11:20:31', '2026-06-28 22:58:32'),
(76, 'OPD-007', '1045893', 'Johnson, Marcus James', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-27 13:15:43', '2026-06-28 22:58:32'),
(77, 'OPD-009', '1045895', 'Smith, David Alan', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-27 13:17:17', '2026-06-28 22:58:32'),
(78, 'OPD-012', '1045896', 'Patel, Aisha Fatima', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-27 13:20:26', '2026-06-28 22:58:32'),
(79, 'OPD-013', '1045897', 'Davis, William Thomas', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-27 13:24:39', '2026-06-28 22:58:32'),
(80, 'OPD-014', '1045898', 'Taylor, Olivia Grace', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-27 13:25:57', '2026-06-28 22:58:32'),
(81, 'OPD-019', '1045901', 'Rodriguez, Alexander', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-27 13:34:58', '2026-06-28 22:58:32'),
(82, 'OPD-020', '1045902', 'Wilson, Isabella Rose', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-27 13:45:01', '2026-06-28 22:58:32'),
(83, 'OPD-021', '1045903', 'Anderson, James Michael', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-27 15:35:14', '2026-06-28 22:58:32'),
(84, 'HM-003', '1045904', 'Thomas, Charlotte Elizabeth', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-27 15:40:55', '2026-06-28 22:58:32'),
(85, 'HM-001', '1045905', 'Jackson, Benjamin David', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-27 15:41:54', '2026-06-28 22:58:32'),
(90, 'HM-001', '1045892', 'Chen, Emily Rose', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-28 22:58:34', '2026-06-30 08:46:58'),
(91, 'HM-002', '1045893', 'Johnson, Marcus James', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-28 23:04:07', '2026-06-30 08:46:58'),
(93, 'CM-001', '1045895', 'Smith, David Alan', 'Chemotherapy', 'Wrong patient record selected', 'jaystellman', '2026-06-30 09:26:18', '2026-06-30 09:37:37'),
(94, 'CM-006', '1045896', 'Patel, Aisha Fatima', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-06-30 09:59:04', '2026-06-30 09:59:12'),
(95, 'CM-007', '1045896', 'Patel, Aisha Fatima', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-06-30 09:59:16', '2026-06-30 09:59:31'),
(96, 'HM-003', '1045894', 'Martinez, Sophia Marie', 'Hemodialysis', 'Cutoff', 'jaystellman', '2026-06-30 13:14:40', '2026-06-30 15:47:50'),
(97, 'HM-002', '1045893', 'Johnson, Marcus James', 'Hemodialysis', 'Cutoff', 'jaystellman', '2026-06-30 09:24:57', '2026-06-30 15:47:55'),
(98, 'HM-001', '1045892', 'Chen, Emily Rose', 'Hemodialysis', 'Cutoff', 'jaystellman', '2026-06-30 08:46:59', '2026-06-30 15:48:00'),
(99, 'CM-010', '1045893', 'Johnson, Marcus James', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-06-30 13:15:06', '2026-07-01 08:11:49'),
(100, 'HT-001', '1045895', 'Smith, David Alan', 'Hearing Test', 'Auto-flushed: Day has passed', 'system', '2026-06-30 13:15:25', '2026-07-01 08:11:49'),
(101, 'OPD-001', '1045897', 'Davis, William Thomas', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-06-30 13:15:40', '2026-07-01 08:11:49'),
(102, 'CM-011', '1045894', 'Martinez, Sophia Marie', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-06-30 14:38:48', '2026-07-01 08:11:49'),
(103, 'HT-002', '1045896', 'Patel, Aisha Fatima', 'Hearing Test', 'Auto-flushed: Day has passed', 'system', '2026-06-30 15:14:39', '2026-07-01 08:11:49'),
(104, 'HM-004', '1045892', 'Chen, Emily Rose', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-06-30 15:48:12', '2026-07-01 08:11:49'),
(105, 'RD-004', '1045904', 'Thomas, Charlotte Elizabeth', 'Radiology', 'Auto-flushed: Day has passed', 'system', '2026-06-30 21:45:40', '2026-07-01 08:11:49'),
(128, 'CM-046', '1045956', 'Williams, James Robert', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-01 14:10:21', '2026-07-01 14:19:55'),
(129, 'CM-049', '1045957', 'Williams, James Robert', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-01 14:21:11', '2026-07-01 14:21:17'),
(130, 'CM-050', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-01 14:21:37', '2026-07-01 14:21:42'),
(131, 'CM-051', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-01 14:22:02', '2026-07-01 14:22:10'),
(132, 'CM-053', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-01 14:24:38', '2026-07-01 14:24:44'),
(133, 'CM-059', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Did not appear after calling', 'hi', '2026-07-01 15:48:43', '2026-07-01 16:45:15'),
(134, 'RD-013', '1045969', 'Lee, Christopher John', 'Radiology', 'Auto-flushed: Day has passed', 'system', '2026-07-01 10:42:17', '2026-07-02 08:06:13'),
(135, 'HM-003', '1045970', 'Stellman, Jay', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-07-01 10:42:26', '2026-07-02 08:06:13'),
(136, 'XR-001', '1045970', 'Stellman, Jay', 'X-Ray', 'Auto-flushed: Day has passed', 'system', '2026-07-01 10:45:31', '2026-07-02 08:06:13'),
(137, 'OR-001', '1045970', 'Stellman, Jay', 'OR', 'Auto-flushed: Day has passed', 'system', '2026-07-01 10:45:55', '2026-07-02 08:06:13'),
(138, 'OPD-001', '1045970', 'Stellman, Jay', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-07-01 10:46:06', '2026-07-02 08:06:13'),
(139, 'HT-001', '1045970', 'Stellman, Jay', 'Hearing Test', 'Auto-flushed: Day has passed', 'system', '2026-07-01 10:46:17', '2026-07-02 08:06:13'),
(140, 'ER-001', '1045970', 'Stellman, Jay', 'ER', 'Auto-flushed: Day has passed', 'system', '2026-07-01 10:46:44', '2026-07-02 08:06:13'),
(141, 'EC-001', '1045970', 'Stellman, Jay', 'Eye Center', 'Auto-flushed: Day has passed', 'system', '2026-07-01 10:46:53', '2026-07-02 08:06:13'),
(142, 'RD-014', '1045970', 'Stellman, Jay', 'Radiology', 'Auto-flushed: Day has passed', 'system', '2026-07-01 10:59:17', '2026-07-02 08:06:13'),
(143, 'EC-002', '1045969', 'Lee, Christopher John', 'Eye Center', 'Auto-flushed: Day has passed', 'system', '2026-07-01 14:25:53', '2026-07-02 08:06:13'),
(144, 'CM-054', '1045965', 'Lee, Michael David', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-01 14:39:26', '2026-07-02 08:06:13'),
(145, 'CM-055', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-01 14:58:38', '2026-07-02 08:06:13'),
(146, 'CM-056', '1045967', 'Lee, David Joseph', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-01 15:20:53', '2026-07-02 08:06:13'),
(147, 'CM-057', '1045968', 'Lee, Emily Rose', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-01 15:45:44', '2026-07-02 08:06:13'),
(148, 'CM-058', '1045969', 'Lee, Christopher John', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-01 15:48:06', '2026-07-02 08:06:13'),
(149, 'CM-060', '1045964', 'Taylor, Sarah Lynn', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-01 16:35:41', '2026-07-02 08:06:13'),
(150, 'CM-061', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-01 16:45:45', '2026-07-02 08:06:13'),
(165, 'CM-002', '1045940', 'Smith, John Edward', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-02 08:36:31', '2026-07-02 09:00:51'),
(166, 'CM-001', '1045950', 'Jones, Robert', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-02 08:36:21', '2026-07-02 09:00:54'),
(167, 'CM-003', '1045930', 'Roberts, Layla Marie', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-02 08:36:38', '2026-07-02 09:00:58'),
(168, 'CM-004', '1045920', 'Hill, Grace Ann', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-02 08:36:45', '2026-07-02 09:01:02'),
(169, 'CM-005', '1045910', 'Rodriguez, Evelyn', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-02 08:36:52', '2026-07-02 09:01:05'),
(170, 'CM-006', '1045900', 'Garcia, Mia Isabella', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-02 08:37:01', '2026-07-02 09:01:09'),
(171, 'CM-007', '1045901', 'Rodriguez, Alexander', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-02 08:37:08', '2026-07-02 09:01:12'),
(172, 'EC-001', '1045970', 'Stellman, Jay', 'Eye Center', 'Auto-flushed: Day has passed', 'system', '2026-07-02 08:06:17', '2026-07-03 11:19:47'),
(173, 'CM-009', '1045903', 'Anderson, James Michael', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-02 08:37:21', '2026-07-03 11:19:47'),
(174, 'CM-010', '1045904', 'Thomas, Charlotte Elizabeth', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-02 08:37:25', '2026-07-03 11:19:47'),
(175, 'CM-011', '1045905', 'Jackson, Benjamin David', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-02 08:37:31', '2026-07-03 11:19:47'),
(176, 'CM-012', '1045906', 'White, Amelia Grace', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-02 08:37:39', '2026-07-03 11:19:47'),
(180, 'CM-002', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-03 11:22:45', '2026-07-03 11:30:24'),
(181, 'EC-001', '1045965', 'Lee, Michael David', 'Eye Center', 'Auto-flushed: Day has passed', 'system', '2026-07-03 11:39:32', '2026-07-07 14:03:37'),
(182, 'ER-001', '1045965', 'Lee, Michael David', 'ER', 'Auto-flushed: Day has passed', 'system', '2026-07-03 11:39:39', '2026-07-07 14:03:37'),
(183, 'HM-001', '1045965', 'Lee, Michael David', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-07-03 11:39:51', '2026-07-07 14:03:37'),
(184, 'HT-001', '1045965', 'Lee, Michael David', 'Hearing Test', 'Auto-flushed: Day has passed', 'system', '2026-07-03 11:39:58', '2026-07-07 14:03:37'),
(185, 'OPD-001', '1045965', 'Lee, Michael David', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-07-03 11:40:05', '2026-07-07 14:03:37'),
(186, 'OR-001', '1045965', 'Lee, Michael David', 'OR', 'Auto-flushed: Day has passed', 'system', '2026-07-03 11:40:13', '2026-07-07 14:03:37'),
(187, 'RD-001', '1045965', 'Lee, Michael David', 'Radiology', 'Auto-flushed: Day has passed', 'system', '2026-07-03 11:40:22', '2026-07-07 14:03:37'),
(188, 'XR-001', '1045965', 'Lee, Michael David', 'X-Ray', 'Auto-flushed: Day has passed', 'system', '2026-07-03 11:40:33', '2026-07-07 14:03:37'),
(189, 'CM-001', '1045965', 'Lee, Michael David', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-07 14:03:39', '2026-07-20 10:14:08'),
(190, 'CM-002', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-07 14:04:56', '2026-07-20 10:14:08'),
(191, 'CM-003', '1045967', 'Lee, David Joseph', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-07 14:33:26', '2026-07-20 10:14:08'),
(194, 'CM-003', '1045893', 'Johnson, Marcus James', 'Chemotherapy', 'Wrong patient record selected', 'jaystellman', '2026-07-20 10:26:38', '2026-07-20 10:32:10'),
(195, 'CM-001', '1045892', 'Chen, Emily Rose', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-07-20 10:14:28', '2026-07-20 10:37:20'),
(196, 'CM-002', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-07-21 13:51:59', '2026-07-21 13:52:35'),
(197, 'CM-016', '1045958', 'Williams, James Robert', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-07-21 14:55:17', '2026-07-21 16:29:27'),
(198, 'CM-021', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-07-21 16:30:46', '2026-07-21 16:31:28'),
(199, 'CM-018', '1045965', 'Lee, Michael David', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-21 16:30:21', '2026-07-21 16:32:58'),
(200, 'CM-019', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-21 16:30:27', '2026-07-21 16:33:18'),
(201, 'CM-020', '1045967', 'Lee, David Joseph', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-21 16:30:33', '2026-07-21 16:33:46'),
(202, 'CM-023', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-07-21 16:34:33', '2026-07-21 16:36:40'),
(203, 'CM-025', '1045968', 'Lee, Emily Rose', 'Chemotherapy', 'Cutoff', 'jaystellman', '2026-07-21 16:34:45', '2026-07-21 16:38:26'),
(204, 'EC-001', '1045967', 'Lee, David Joseph', 'Eye Center', 'Auto-flushed: Day has passed', 'system', '2026-07-21 13:55:10', '2026-07-24 11:38:52'),
(205, 'ER-001', '1045967', 'Lee, David Joseph', 'ER', 'Auto-flushed: Day has passed', 'system', '2026-07-21 13:55:16', '2026-07-24 11:38:52'),
(206, 'OR-001', '1045967', 'Lee, David Joseph', 'OR', 'Auto-flushed: Day has passed', 'system', '2026-07-21 13:55:23', '2026-07-24 11:38:52'),
(207, 'HM-001', '1045967', 'Lee, David Joseph', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-07-21 13:55:31', '2026-07-24 11:38:52'),
(208, 'HT-001', '1045967', 'Lee, David Joseph', 'Hearing Test', 'Auto-flushed: Day has passed', 'system', '2026-07-21 13:55:38', '2026-07-24 11:38:52'),
(209, 'OPD-001', '1045967', 'Lee, David Joseph', 'OPD', 'Auto-flushed: Day has passed', 'system', '2026-07-21 13:55:51', '2026-07-24 11:38:52'),
(210, 'RD-001', '1045967', 'Lee, David Joseph', 'Radiology', 'Auto-flushed: Day has passed', 'system', '2026-07-21 13:55:59', '2026-07-24 11:38:52'),
(211, 'XR-001', '1045967', 'Lee, David Joseph', 'X-Ray', 'Auto-flushed: Day has passed', 'system', '2026-07-21 13:56:07', '2026-07-24 11:38:52'),
(219, 'CM-001', '1045965', 'Lee, Michael David', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-24 11:38:54', '2026-07-24 11:49:03'),
(220, 'CM-003', '1045965', 'Lee, Michael David', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-24 12:17:21', '2026-07-24 12:20:53'),
(221, 'CM-004', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-24 12:19:02', '2026-07-24 12:20:57'),
(222, 'CM-005', '1045967', 'Lee, David Joseph', 'Chemotherapy', 'Did not appear after calling', 'jaystellman', '2026-07-24 12:20:37', '2026-07-24 12:21:02'),
(223, 'HM-003', '1045967', 'Lee, David Joseph', 'Hemodialysis', 'Did not appear after calling', 'counter_admin', '2026-07-24 13:08:49', '2026-07-24 13:09:04'),
(224, 'HM-002', '1045966', 'Lee, Jessica Nicole', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-07-24 13:07:00', '2026-07-27 08:40:09'),
(225, 'CM-002', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Cutoff', 'chemoadmin', '2026-07-27 08:40:21', '2026-07-27 10:41:02'),
(226, 'CM-006', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Cutoff', 'chemoadmin', '2026-07-27 09:45:05', '2026-07-27 11:52:49'),
(227, 'CM-005', '1045969', 'Lee, Christopher John', 'Chemotherapy', 'Cutoff', 'chemoadmin', '2026-07-27 09:44:32', '2026-07-27 12:55:16'),
(228, 'CM-003', '1045967', 'Lee, David Joseph', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 09:43:16', '2026-07-28 09:30:36'),
(229, 'CM-004', '1045968', 'Lee, Emily Rose', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 09:44:03', '2026-07-28 09:30:36'),
(230, 'CM-007', '1045964', 'Taylor, Sarah Lynn', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 09:45:41', '2026-07-28 09:30:36'),
(231, 'CM-008', '1045963', 'Taylor, Sarah', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 09:46:04', '2026-07-28 09:30:36'),
(232, 'CM-009', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 11:54:49', '2026-07-28 09:30:36'),
(233, 'CM-010', '1045892', 'Chen, Emily Rose', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:13:44', '2026-07-28 09:30:36'),
(234, 'CM-011', '1045893', 'Johnson, Marcus James', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:15:12', '2026-07-28 09:30:36'),
(235, 'CM-012', '1045894', 'Martinez, Sophia Marie', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:16:28', '2026-07-28 09:30:36'),
(236, 'CM-013', '1045895', 'Smith, David Alan', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:16:39', '2026-07-28 09:30:36'),
(237, 'CM-014', '1045896', 'Patel, Aisha Fatima', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:17:10', '2026-07-28 09:30:36'),
(238, 'CM-015', '1045897', 'Davis, William Thomas', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:17:22', '2026-07-28 09:30:36'),
(239, 'CM-016', '1045898', 'Taylor, Olivia Grace', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:17:33', '2026-07-28 09:30:36'),
(240, 'CM-017', '1045899', 'Brown, Ethan Daniel', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:17:47', '2026-07-28 09:30:36'),
(241, 'CM-018', '1045900', 'Garcia, Mia Isabella', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:17:57', '2026-07-28 09:30:36'),
(242, 'EC-001', '1045965', 'Lee, Michael David', 'Eye Center', 'Auto-flushed: Day has passed', 'system', '2026-07-27 13:30:01', '2026-07-28 09:30:36'),
(243, 'CM-004', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Wrong patient record selected', 'counter_staff', '2026-07-28 14:15:05', '2026-07-28 14:15:13'),
(245, 'CM-005', '1045969', 'Lee, Christopher John', 'Chemotherapy', 'Did not appear after calling', 'counter_staff', '2026-07-28 14:30:17', '2026-07-28 16:13:49'),
(246, 'HM-001', '1045969', 'Lee, Christopher John', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-07-28 14:18:10', '2026-08-03 09:57:15'),
(247, 'HM-002', '1045970', 'Stellman, Jay', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-07-28 14:18:17', '2026-08-03 09:57:15'),
(248, 'CM-007', '1045965', 'Lee, Michael David', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-07-28 16:55:22', '2026-08-03 09:57:15'),
(250, 'HM-001', '1045965', 'Lee, Michael David', 'Hemodialysis', 'Auto-flushed: Day has passed', 'system', '2026-08-03 09:57:17', '2026-08-10 12:16:05'),
(251, 'EC-001', '1045965', 'Lee, Michael David', 'Eye Center', 'Auto-flushed: Day has passed', 'system', '2026-08-03 10:23:51', '2026-08-10 12:16:05'),
(252, 'ER-001', '1045965', 'Lee, Michael David', 'ER', 'Auto-flushed: Day has passed', 'system', '2026-08-03 10:24:00', '2026-08-10 12:16:05'),
(253, 'HT-001', '1045965', 'Lee, Michael David', 'Hearing Test', 'Auto-flushed: Day has passed', 'system', '2026-08-03 10:24:11', '2026-08-10 12:16:05'),
(254, 'CM-002', '1045966', 'Lee, Jessica Nicole', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-08-03 14:11:49', '2026-08-10 12:16:05'),
(257, 'CM-001', '1045970', 'Stellman, Jay', 'Chemotherapy', 'ocr', 'chemoadmin', '2026-08-10 14:23:33', '2026-08-10 14:54:55'),
(258, 'CM-003', '1045970', 'Stellman, Jay', 'Chemotherapy', 'ocr', 'chemoadmin', '2026-08-10 14:55:14', '2026-08-10 19:46:50'),
(259, 'CM-002', '1045969', 'Lee, Christopher John', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-08-10 14:47:54', '2026-08-16 00:11:40'),
(260, 'CM-004', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-08-10 19:48:43', '2026-08-16 00:11:40'),
(266, 'CM-003', '1045967', 'Lee, David Joseph', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-08-16 00:14:33', '2026-08-23 23:05:57'),
(267, 'CM-007', '1045970', 'Stellman, Jay', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-08-16 17:12:17', '2026-08-23 23:05:57'),
(268, 'OR-001', '1045965', 'Lee, Michael David', 'OR', 'Auto-flushed: Day has passed', 'system', '2026-08-16 17:50:27', '2026-08-23 23:05:57'),
(269, 'OR-002', '1045970', 'Stellman, Jay', 'OR', 'Auto-flushed: Day has passed', 'system', '2026-08-16 17:51:25', '2026-08-23 23:05:57'),
(270, 'CM-008', '1045968', 'Lee, Emily Rose', 'Chemotherapy', 'Auto-flushed: Day has passed', 'system', '2026-08-16 17:52:24', '2026-08-23 23:05:57'),
(271, 'EC-001', '1045970', 'Stellman, Jay', 'Eye Center', 'Auto-flushed: Day has passed', 'system', '2026-08-16 21:50:58', '2026-08-23 23:05:57'),
(273, 'CM-001', '1045970', 'Stellman, Jay', 'Chemotherapy', 'a', 'counter_staff', '2026-08-23 23:05:58', '2026-08-23 23:12:14'),
(274, 'CM-001', '1045970', 'Stellman, Jay', 'Chemotherapy', 'a', 'chemoadmin', '2026-08-24 12:57:57', '2026-08-24 12:58:03');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `ID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `department` varchar(50) NOT NULL,
  `privileges` varchar(10) NOT NULL,
  `staff_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`ID`, `username`, `password_hash`, `department`, `privileges`, `staff_name`) VALUES
(1, 'jaystellman', '$2y$10$Y4MURVyk.MVqZVO96O5soOudwDLcKMls7AquMTwG.oDGftH/fLu5q', 'Hemodialysis', 'admin', 'Stellman, Jay'),
(3, 'counter_staff', '$2y$10$WBi5m9MvVFQr56TA0EUqqObJuIO4Qase2hXod2HVcjY/9aMPeO01q', 'Counter', 'staff', 'Counter Staff'),
(4, 'counter_admin', '$2y$10$EFb81va8hDXpihVm6v54Oun2dDjbYXff.jndDnFGvT.nTMLDUU5g6', 'Counter', 'admin', 'Counter Admin'),
(5, 'hemodialysis_staff', '$2y$10$/u8hB4ZLoOoChEPDNd/byu582Sy2n72iLF0iOLqEJ9vZAtN10Sbom', 'Hemodialysis', 'staff', 'Hemodialysis Staff'),
(6, 'chemoadmin', '$2y$10$6KQICoytH23nuzXWwUrqZuYH7jNsJ/OQzs73mcSZlNfSEDFk9kr4W', 'Chemotherapy', 'admin', 'Chemotherapy Admin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_completed`
--
ALTER TABLE `tbl_completed`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tbl_department_counters`
--
ALTER TABLE `tbl_department_counters`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tbl_last_page_updates`
--
ALTER TABLE `tbl_last_page_updates`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tbl_queues`
--
ALTER TABLE `tbl_queues`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tbl_removed`
--
ALTER TABLE `tbl_removed`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_completed`
--
ALTER TABLE `tbl_completed`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=227;

--
-- AUTO_INCREMENT for table `tbl_department_counters`
--
ALTER TABLE `tbl_department_counters`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tbl_last_page_updates`
--
ALTER TABLE `tbl_last_page_updates`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_queues`
--
ALTER TABLE `tbl_queues`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=457;

--
-- AUTO_INCREMENT for table `tbl_removed`
--
ALTER TABLE `tbl_removed`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=275;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- Database: `test`
--
DROP DATABASE IF EXISTS `test`;
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
--
-- Database: `verifigate`
--
DROP DATABASE IF EXISTS `verifigate`;
CREATE DATABASE IF NOT EXISTS `verifigate` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `verifigate`;
--
-- Database: `wikaendb`
--
DROP DATABASE IF EXISTS `wikaendb`;
CREATE DATABASE IF NOT EXISTS `wikaendb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `wikaendb`;

-- --------------------------------------------------------

--
-- Table structure for table `grammar`
--

CREATE TABLE `grammar` (
  `id` int(9) NOT NULL,
  `level` varchar(18) NOT NULL,
  `sentence` varchar(100) NOT NULL,
  `options` varchar(50) NOT NULL,
  `answer` varchar(30) NOT NULL,
  `info` varchar(3000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grammar`
--

INSERT INTO `grammar` (`id`, `level`, `sentence`, `options`, `answer`, `info`) VALUES
(1, 'beginner', 'I like to ___ cake.', 'eat;ate;eats', 'eat', ''),
(2, 'beginner', 'I\'m ___ to sleep.', 'go;goes;going', 'going', ''),
(3, 'beginner', 'I like to ___ books.', 'read;reading;reads', 'read', ''),
(4, 'beginner', 'Many people ___ at the park.', 'was;were;we\'re', 'were', ''),
(5, 'beginner', 'I see ___ green grass.', 'a;the;an', 'the', ''),
(6, 'level_exam', 'If I ___ the resources, I would launch the project immediately.', 'were to have;would have;has', 'were to have', ''),
(7, 'level_exam', 'The committee insisted that the new policy ___ implemented by the end of the fiscal quarter.', 'is;will be;be', 'be', ''),
(8, 'level_exam', 'The report criticized the lack of clarity in the proposal, ___ an immediate revision.', 'calling for;which called for;calling', 'calling for', ''),
(9, 'level_exam', 'She was not only an excellent orator ___ a remarkably effective negotiator.', 'but also;as well as;and also', 'but also', ''),
(10, 'intermediate', 'I was ___ yesterday.', 'there;their;they\'re', 'there', ''),
(11, 'advanced', 'I don\'t see him, ___ his son.', 'or;nor;and', 'nor', ''),
(12, 'advanced', 'I studied hard yesterday, ___ I didn\'t pass.', 'yet;so;nor', 'yet', ''),
(13, 'intermediate', 'Every boy must bring ___ own bag.', 'their;his;him', 'his', ''),
(14, 'intermediate', '____ waiting for you.', 'They\'re;There;Their', 'They\'re', ''),
(15, 'intermediate', 'I will see you ___.', 'there;theirs;they\'re', 'there', ''),
(16, 'intermediate', '___ late.', 'Your;You\'re;You', 'You\'re', ''),
(17, 'intermediate', 'I have ___ backpack.', 'your:you\'re:your\'e', 'your', ''),
(18, 'intermediate', 'It had a negative ___.', 'affect;effect;effiective', 'effect', ''),
(19, 'intermediate', 'The disease can ___ your health.', 'effect;affect;effective', 'affect', ''),
(20, 'intermediate', 'It is ___ historical event.', 'an;a;of', 'an', ''),
(21, 'beginner', 'I am a ___.', 'beginner;engineer;astronaut', 'beginner', ''),
(22, 'intermediate', 'I ___ hungry, but I\'m full now.', 'had been;have;have been', 'had been', ''),
(23, 'advanced', 'His report was bad, but it ___ an impact on management', 'have;had had;have had', 'had had', ''),
(24, 'intermediate', 'I ___ been more careful.', 'had;should have;should had', 'should have', ''),
(25, 'beginner', 'They ___ a couple.', 'is;are;was', 'are', ''),
(26, 'intermediate', 'They ___ here, but they already left.', 'were;we\'re;where', 'were', ''),
(27, 'intermediate', 'He was here, but he ___.', 'left already;leaves;already left', 'already left', ''),
(28, 'intermediate', '___ here.', 'We\'re;Were\'Where', 'We\'re', ''),
(29, 'intermediate', 'We ____ able to complete the task', 'were;we\'re;where', 'were', ''),
(30, 'advanced', 'I ___ prayed more.', 'will have;must have;should have', 'should have', ''),
(31, 'advanced', 'I am ready, ___ I haven\'t done it.', 'yet;but;nor', 'yet', ''),
(32, 'beginner', 'I\'ll have a cup of ___, please.', 'the coffee;coffee;coffees', 'coffee', ''),
(33, 'advanced', 'In the future, what once took a year ___ in a day.', 'could be;could be done;could take', '', ''),
(34, 'intermediate', '___ should pass it today.', 'Everyone;Every one;Some one', 'Everyone', ''),
(35, 'intermediate', 'I did it, ___ I was bored.', 'because;thus;and so', 'because', ''),
(36, 'advanced', 'I liked the cinematography, ___ I liked the music.', 'therefore;additionally;likewise', 'likewise', ''),
(37, 'intermediate', 'I ___ have let it happen.', 'shouldn\'t;haven\'t;hasn\'t', 'shouldn\'t', ''),
(38, 'beginner', 'He is ___ a book.', 'writing;wrighting;righting', 'writing', ''),
(39, 'advanced', 'I ___ the chance to do the task.', 'haven\'t;haven\'t had;had have', 'haven\'t had', ''),
(40, 'beginner_exam', 'She often ___ coffee in the morning.', 'drink;drinks;drinking', 'drinks', ''),
(41, 'beginner_exam', 'They ___ to the park every Sunday.', 'goes;go;is go', 'go', ''),
(42, 'beginner_exam', 'We ___ watching a movie right now.', 'is;are;be', 'are', ''),
(43, 'beginner_exam', 'Yesterday, I ___ to the store for milk.', 'go;goed;went', 'went', ''),
(44, 'beginner_exam', 'He ___ his room last night.', 'clean;cleaning;cleaned', 'cleaned', ''),
(45, 'beginner_exam', 'I need ___ umbrella because it is raining.', 'a;an;the', 'an', ''),
(46, 'beginner_exam', 'My mom is ___ engineer at the factory.', 'a;an;the', 'an', ''),
(47, 'beginner_exam', 'Please close ___ door. It is cold.', 'a;an;the', 'the', ''),
(48, 'beginner_exam', 'I wake up ___ 7 o\'clock every day.', 'in;on;at', 'at', ''),
(49, 'beginner_exam', 'The party is ___ Saturday evening.', 'in;on;at', 'on', ''),
(50, 'beginner_exam', 'The book is ___ the table.', 'in;on;at', 'on', ''),
(51, 'beginner_exam', 'My clothes are ___ the closet.', 'on;at;in', 'in', ''),
(52, 'beginner_exam', '___ are going to study together tonight.', 'Us;We;Our', 'We', ''),
(53, 'beginner_exam', 'Please give the ball to ___ and not to him.', 'I;me;my', 'me', ''),
(54, 'beginner_exam', 'Is this ___ car?', 'yours;you;your', 'your', ''),
(55, 'beginner_exam', 'He ___ speak three languages fluently.', 'can;cans;is can', 'can', ''),
(56, 'beginner_exam', 'There are ___ apples left in the basket.', 'much;many;little', 'many', ''),
(57, 'beginner_exam', 'Do you have ___ water?', 'many;a few;much', 'much', ''),
(58, 'beginner_exam', '___ you like to have some tea?', 'Are;Do;Is', 'Do', ''),
(59, 'beginner_exam', 'I am ___ tired to walk home.', 'too;to;two', 'too', ''),
(60, 'beginner', 'She ___ happy.', 'is;are;am', 'is', ''),
(61, 'beginner', 'They ___ playing outside.', 'is;are;am', 'are', ''),
(62, 'beginner', 'I ___ a student.', 'is;are;am', 'am', ''),
(63, 'beginner', 'The dog ___ its tail.', 'wag;wags;wagged', 'wags', ''),
(64, 'beginner', 'We ___ to the park yesterday.', 'go;goes;went', 'went', ''),
(65, 'beginner', 'He ___ an apple.', 'eat;eats;eating', 'eats', ''),
(66, 'beginner', 'My mom ___ dinner now.', 'cook;cooked;is cooking', 'is cooking', ''),
(67, 'beginner', 'We ___ TV every night.', 'watch;watches;watched', 'watch', ''),
(68, 'beginner', 'Where ___ my keys?', 'is;are;am', 'are', ''),
(69, 'beginner', 'The cat is sleeping ___ the chair.', 'on;at;in', 'on', ''),
(70, 'beginner', 'I wake up ___ seven o’clock.', 'at;on;in', 'at', ''),
(71, 'beginner', 'She is standing ___ the door.', 'in;at;under', 'at', ''),
(72, 'beginner', 'We live ___ a big city.', 'on;at;in', 'in', ''),
(73, 'beginner', 'I want ___ new book.', 'a;an;the', 'a', ''),
(74, 'beginner', 'She has ___ umbrella.', 'a;an;the', 'an', ''),
(75, 'beginner', '___ sun is bright today.', 'A;An;The', 'The', ''),
(76, 'beginner', 'I see ___ bird flying.', 'a;an;the', 'a', ''),
(77, 'beginner', 'This is ___ idea.', 'a;an;the', 'an', ''),
(78, 'beginner', 'Give the book to ___.', 'I;she;him', 'him', ''),
(79, 'beginner', '___ is my best friend.', 'She;Her;Hers', 'She', ''),
(80, 'beginner', 'This phone is ___.', 'my;mine;I', 'mine', ''),
(81, 'beginner', '___ car is red.', 'We;Our;Us', 'Our', ''),
(82, 'beginner', '___ need to study.', 'They;Them;Their', 'They', ''),
(83, 'beginner', 'I like to ___ fast.', 'run;runs;running', 'run', ''),
(84, 'beginner', 'He ___ a doctor in the hospital.', 'work;works;working', 'works', ''),
(85, 'beginner', 'They ___ football tomorrow.', 'play;played;will play', 'will play', ''),
(86, 'beginner', 'I ___ finished my homework yet.', 'have not;do not;am not', 'have not', ''),
(87, 'beginner', 'She ___ taller than me.', 'is;are;be', 'is', ''),
(88, 'beginner', 'We ___ in the library.', 'is;are;am', 'are', ''),
(89, 'beginner', 'The flowers ___ beautiful.', 'is;are;am', 'are', ''),
(90, 'beginner', 'Can I have ___ water, please?', 'some;any;a', 'some', ''),
(91, 'beginner', 'I don\'t have ___ money.', 'some;any;a', 'any', ''),
(92, 'beginner', 'There is ___ milk in the fridge.', 'many;much;a lot of', 'a lot of', ''),
(93, 'beginner', 'How ___ apples do you have?', 'many;much;a lot of', 'many', ''),
(94, 'beginner', 'How ___ sugar do you need?', 'many;much;a lot of', 'much', ''),
(95, 'beginner', 'This coat is ___.', 'my;mine;me', 'mine', ''),
(96, 'beginner', 'Is this pen ___?', 'you;your;yours', 'yours', ''),
(97, 'beginner', 'He bought a gift for ___.', 'she;her;hers', 'her', ''),
(98, 'beginner', 'The book is ___ the table.', 'under;on;in', 'on', ''),
(99, 'beginner', 'The girl is hiding ___ the tree.', 'behind;next;in front', 'behind', ''),
(100, 'beginner', 'He is talking ___ his mother.', 'to;at;for', 'to', ''),
(101, 'beginner', 'We walked ___ the street.', 'across;at;in', 'across', ''),
(102, 'beginner', 'She ___ tired after school.', 'feel;feels;feeling', 'feels', ''),
(103, 'beginner', 'The children ___ quietly.', 'sit;sits;sitting', 'are sitting', ''),
(104, 'beginner', 'I ___ a letter last week.', 'write;wrote;written', 'wrote', ''),
(105, 'beginner', 'We ___ sing very well.', 'can;cans;canning', 'can', ''),
(106, 'beginner', '___ bike is this?', 'Who;Whose;Who\'s', 'Whose', ''),
(107, 'beginner', 'She likes to ___ music.', 'listen;listens;listening', 'listen', ''),
(108, 'beginner', 'I will meet you ___ the corner.', 'at;on;in', 'at', ''),
(109, 'beginner', 'You look happy. What ___?', 'happens;is happening;happened', 'is happening', ''),
(110, 'intermediate', 'If I ___ enough money, I would travel the world.', 'have;had;would have', 'had', ''),
(111, 'intermediate', 'She ___ here since 2010.', 'lived;has lived;is living', 'has lived', ''),
(112, 'intermediate', 'By the time you arrive, I ___ the project.', 'will finish;will have finished;am finishing', 'will have finished', ''),
(113, 'intermediate', 'The report, ___ was due yesterday, is still not complete.', 'who;which;that', 'which', ''),
(114, 'intermediate', 'You ___ smoke in the hospital.', 'must not;do not have to;should not', 'must not', ''),
(115, 'intermediate', 'If it hadn\'t rained, we ___ camping.', 'would go;would have gone;will go', 'would have gone', ''),
(116, 'intermediate', 'I wish I ___ play the guitar.', 'can;could;will can', 'could', ''),
(117, 'intermediate', 'Despite ___ tired, he kept working.', 'to be;being;is', 'being', ''),
(118, 'intermediate', 'He denied ___ the confidential files.', 'to steal;stealing;stole', 'stealing', ''),
(119, 'intermediate', 'The painting ___ stolen was an original Van Gogh.', 'who;which;that', 'that', ''),
(120, 'intermediate', '___ of the two books is yours?', 'Which;What;Whose', 'Which', ''),
(121, 'intermediate', 'She looks forward to ___ her grandparents.', 'visit;visiting;to visit', 'visiting', ''),
(122, 'intermediate', 'The package was left ___ the front door.', 'beside;between;among', 'beside', ''),
(123, 'intermediate', 'He ___ his sister to look after the cat.', 'made;let;persuaded', 'persuaded', ''),
(124, 'intermediate', 'I regret ___ you the secret.', 'tell;to tell;telling', 'telling', ''),
(125, 'intermediate', 'We would rather ___ in than go out tonight.', 'stay;to stay;staying', 'stay', ''),
(126, 'intermediate', 'She agreed ___ the documents by Friday.', 'to sign;signing;sign', 'to sign', ''),
(127, 'intermediate', 'My flight was delayed, so I ended ___ missing the connection.', 'up;off;out', 'up', ''),
(128, 'intermediate', 'He ___ to his boss about the missed deadline.', 'apologized;apologized to;apologized at', 'apologized to', ''),
(129, 'intermediate', 'They are planning on ___ a new business.', 'setting out;setting up;setting down', 'setting up', ''),
(130, 'intermediate', 'We need to cut ___ on spending this month.', 'off;down;in', 'down', ''),
(131, 'intermediate', 'I\'m completely fed ___ with this noise.', 'in;up;down', 'up', ''),
(132, 'intermediate', 'He speaks English as if he ___ a native speaker.', 'is;were;was', 'were', ''),
(133, 'intermediate', 'Neither the students ___ the teacher was happy with the results.', 'nor;or;and', 'nor', ''),
(134, 'intermediate', 'If you ___ any problems, please call me.', 'will have;have;would have', 'have', ''),
(135, 'intermediate', 'She is the woman ___ son won the scholarship.', 'who;whose;whom', 'whose', ''),
(136, 'intermediate', 'The movie was so boring that I fell ___ in the middle.', 'sleep;asleep;sleeping', 'asleep', ''),
(137, 'intermediate', 'He told me he ___ studying all night for the exam.', 'has been;had been;was been', 'had been', ''),
(138, 'intermediate', 'I ___ afford that car even if I wanted to.', 'can\'t;couldn\'t;might not', 'couldn\'t', ''),
(139, 'intermediate', 'The new policy is ___ to take effect next month.', 'due;owing;bound', 'due', ''),
(140, 'intermediate', 'The coffee was too hot ___ drink.', 'to;for;that', 'to', ''),
(141, 'intermediate', 'She managed ___ the test with a high score.', 'pass;passing;to pass', 'to pass', ''),
(142, 'intermediate', 'He took the job ___ the low salary.', 'although;despite;in spite', 'despite', ''),
(143, 'intermediate', 'We ran out ___ milk this morning.', 'of;off;on', 'of', ''),
(144, 'intermediate', 'I really appreciate ___ me with this task.', 'you helping;your helping;you to help', 'your helping', ''),
(145, 'intermediate', 'If I ___ you, I wouldn\'t take that risk.', 'am;was;were', 'were', ''),
(146, 'intermediate', 'He is used to ___ up early.', 'wake;waking;woke', 'waking', ''),
(147, 'intermediate', 'She had her portrait ___ by a famous artist.', 'paint;painting;painted', 'painted', ''),
(148, 'intermediate', 'The manager insisted ___ the meeting immediately.', 'on starting;to start;start', 'on starting', ''),
(149, 'intermediate', 'Hardly had I sat down ___ the phone rang.', 'than;when;as', 'when', ''),
(150, 'intermediate', 'The factory will ___ production next week.', 'put off;take up;step up', 'step up', ''),
(151, 'intermediate', 'They decided to call ___ the wedding.', 'off;out;away', 'off', ''),
(152, 'intermediate', 'I\'m not used to ___ such spicy food.', 'eat;eating;to eat', 'eating', ''),
(153, 'intermediate', 'He speaks three languages, ___ Spanish.', 'including;include;to include', 'including', ''),
(154, 'intermediate', 'I wish you ___ stop interrupting me.', 'will;would;can', 'would', ''),
(155, 'intermediate', 'The children were so excited ___ the snow.', 'to see;seeing;see', 'to see', ''),
(156, 'intermediate', 'It\'s about time you ___ a better effort.', 'make;made;will make', 'made', ''),
(157, 'intermediate', 'You ___ better tell him the truth.', 'had;should;must', 'had', ''),
(158, 'intermediate', 'This is the place ___ we first met.', 'where;which;that', 'where', ''),
(159, 'intermediate', 'The concert was postponed ___ to bad weather.', 'due;owing;because', 'due', ''),
(160, 'advanced', 'Had I realized the gravity of the situation, I ___ intervened much sooner.', 'would;had;would have', 'would have', ''),
(161, 'advanced', 'It is imperative that the meeting ___ before any action is taken.', 'is held;be held;will be held', 'be held', ''),
(162, 'advanced', 'She is determined to see the project through, ___ daunting the task may be.', 'how;however;no matter', 'however', ''),
(163, 'advanced', 'Only after the initial shock had worn off ___ to appreciate the irony.', 'he began;did he begin;he did begin', 'did he begin', ''),
(164, 'advanced', 'The company\'s success can be entirely ___ to his innovative leadership.', 'ascribed;subscribed;described', 'ascribed', ''),
(165, 'advanced', 'Much ___ the board\'s surprise, the motion was passed unanimously.', 'to;as;for', 'to', ''),
(166, 'advanced', 'Having ___ his entire inheritance on a foolish venture, he was left penniless.', 'wasted;had wasted;been wasting', 'wasted', ''),
(167, 'advanced', '___ for the unforeseen expenses, the budget would have been perfectly balanced.', 'But;Unless;Had it not been', 'Had it not been', ''),
(168, 'advanced', 'It\'s high time the government ___ decisive action on climate change.', 'take;took;is taking', 'took', ''),
(169, 'advanced', 'The committee is currently ___ of seven permanent members and three advisors.', 'comprised;composing;comprised of', 'comprised of', ''),
(170, 'advanced', 'The speaker\'s rhetoric was so powerful as to ___ the audience into immediate action.', 'instigate;provoke;incite', 'incite', ''),
(171, 'advanced', 'The antique vase, ___ had been passed down through generations, was accidentally broken.', 'that;which;whom', 'which', ''),
(172, 'advanced', 'She spent most of her formative years ___ a sense of unwavering moral integrity.', 'inculcating;instilling;ingraining', 'instilling', ''),
(173, 'advanced', 'He speaks five languages, ___ his native Russian.', 'besides;apart;in addition', 'besides', ''),
(174, 'advanced', 'The negotiations reached an impasse, ___ neither side was willing to concede ground.', 'with;where;in which', 'in which', ''),
(175, 'advanced', 'Never ___ a more compelling performance in my entire life.', 'have I seen;I have seen;I ever saw', 'have I seen', ''),
(176, 'advanced', 'They were forced to ___ the entire journey due to the train strike.', 'foot;go on foot;do on foot', 'foot', ''),
(177, 'advanced', 'The proposal was rejected, ___ which led to his subsequent resignation.', 'all of which;which all;which', 'all of which', ''),
(178, 'advanced', 'I wish I ___ a more proactive stance during the crisis.', 'took;have taken;had taken', 'had taken', ''),
(179, 'advanced', 'The sheer volume of evidence ___ to the defendant\'s guilt.', 'attest;attests;are attesting', 'attests', ''),
(180, 'advanced', 'The CEO made it ___ that insubordination would not be tolerated.', 'clear;clearly;cleared', 'clear', ''),
(181, 'advanced', '___ the difficulty of the task, he tackled it with remarkable enthusiasm.', 'Despite;Although;In spite', 'Despite', ''),
(182, 'advanced', 'If he ___ a little more time, he would have completed the intricate analysis.', 'had been given;were given;was given', 'had been given', ''),
(183, 'advanced', 'Not only ___ a profound thinker, but he was also a skilled orator.', 'he was;was he;did he be', 'was he', ''),
(184, 'advanced', '___ is evident from the findings, the project requires a complete overhaul.', 'That;What;As', 'As', ''),
(185, 'advanced', 'The government is coming ___ pressure to relax immigration laws.', 'under;in;for', 'under', ''),
(186, 'advanced', 'I\'m not used to ___ such complex theories in my day-to-day work.', 'deal with;dealing with;be dealing with', 'dealing with', ''),
(187, 'advanced', 'The controversial policy was finally ___ in the face of public outcry.', 'aborted;repealed;revoked', 'repealed', ''),
(188, 'advanced', 'It\'s about time you ___ responsibility for your actions.', 'take;took;are taking', 'took', ''),
(189, 'advanced', 'She went to great ___ to ensure the guests felt comfortable.', 'lengths;efforts;extend', 'lengths', ''),
(190, 'advanced', 'The company is widely ___ as a pioneer in sustainable technology.', 'regarded;viewed;considered to be', 'regarded', ''),
(191, 'advanced', 'No sooner had the alarm sounded ___ the security team arrived.', 'when;than;then', 'than', ''),
(192, 'advanced', 'The problem ___ in his inability to delegate tasks effectively.', 'lies;lays;laid', 'lies', ''),
(193, 'advanced', 'Were the funding to be cut, the research project ___ immediately.', 'would stop;will stop;is stopping', 'would stop', ''),
(194, 'advanced', 'The two neighbours, ___ their continuous disputes, are surprisingly dependent on each other.', 'in spite;for all;although', 'for all', ''),
(195, 'advanced', 'The evidence was deemed ___ to secure a conviction.', 'insufficient;not sufficient;un-sufficient', 'insufficient', ''),
(196, 'advanced', 'We were advised ___ the contract thoroughly before signing.', 'to peruse;peruse;perusing', 'to peruse', ''),
(197, 'advanced', 'The book is, ___, the best thriller I have read this year.', 'without doubt;in a doubt;doubtlessly', 'without doubt', ''),
(198, 'advanced', 'He seems quite ___ to the idea of a merger with a rival firm.', 'averse;adverse;reverse', 'averse', ''),
(199, 'advanced', '___ his immense wealth, he leads a remarkably modest life.', 'For all;Despite of;In spite', 'For all', ''),
(200, 'advanced', 'The document needs ___ before it can be submitted to the committee.', 'to be scrutinizing;scrutinizing;scrutinize', 'scrutinizing', ''),
(201, 'advanced', 'The children were utterly ___ by the magician\'s performance.', 'spellbind;spellbound;spellbinding', 'spellbound', ''),
(202, 'advanced', '___ being warned of the risks, they proceeded with the reckless plan.', 'Despite of;In spite;Notwithstanding', 'Notwithstanding', ''),
(203, 'advanced', 'I would rather you ___ about this sensitive matter in public.', 'didn\'t speak;don\'t speak;wouldn\'t speak', 'didn\'t speak', ''),
(204, 'advanced', 'He has a knack ___ simplifying complex technical jargon.', 'for;at;of', 'for', ''),
(205, 'advanced', 'The company must ___ with the new data protection regulations immediately.', 'comply;adhere;conform', 'comply', ''),
(206, 'advanced', 'I was given a substantial grant, which I ___ be incredibly grateful for.', 'must;ought;can only', 'can only', ''),
(207, 'advanced', 'She managed to ___ herself understood despite the language barrier.', 'make;have;get', 'make', ''),
(208, 'advanced', 'The reason ___ he resigned was never made public.', 'why;for;that', 'why', ''),
(209, 'advanced', 'Hardly ___ the presentation started when the fire alarm went off.', 'had;did;was', 'had', ''),
(210, 'intermediate_exam', 'If I ___ enough money, I would travel around the world.', 'have;had;will have', 'had', ''),
(211, 'intermediate_exam', 'She ___ for the bus when it started to rain heavily.', 'waits;was waiting;has waited', 'was waiting', ''),
(212, 'intermediate_exam', 'The movie was so boring that I ___ asleep in the middle of it.', 'fall;fell;fallen', 'fell', ''),
(213, 'intermediate_exam', 'You ___ to finish your homework before you go out to play.', 'must;should;have', 'have', ''),
(214, 'intermediate_exam', 'The package ___ by the courier service tomorrow morning.', 'will deliver;will be delivered;is delivering', 'will be delivered', ''),
(215, 'intermediate_exam', 'He apologized ___ being late for the important meeting.', 'for;about;at', 'for', ''),
(216, 'intermediate_exam', 'I look forward to ___ from you soon regarding my application.', 'hear;hearing;to hear', 'hearing', ''),
(217, 'intermediate_exam', 'I think it ___ snow tonight, as the temperature is dropping fast.', 'might;must;should', 'might', ''),
(218, 'intermediate_exam', 'They ___ in New York since 2018.', 'lived;are living;have lived', 'have lived', ''),
(219, 'intermediate_exam', 'The new bridge will make ___ easier for commuters to reach the city.', 'it;there;that', 'it', ''),
(220, 'intermediate_exam', 'Do you remember ___ to that small Italian restaurant last year?', 'going;to go;go', 'going', ''),
(221, 'intermediate_exam', 'She is the woman ___ helped me find my lost keys.', 'which;who;whose', 'who', ''),
(222, 'intermediate_exam', 'We ___ to the cinema if we finish our dinner in time.', 'go;will go;are going', 'will go', ''),
(223, 'intermediate_exam', 'The car was broken, so we had to call ___ a mechanic.', 'up;for;out', 'out', ''),
(224, 'intermediate_exam', 'My brother is not ___ as me, but he is taller.', 'old;as old;older', 'as old', ''),
(225, 'intermediate_exam', 'When I finally arrived, everyone ___ already left the party.', 'has;had;have', 'had', ''),
(226, 'intermediate_exam', 'It\'s difficult ___ a new language, but it\'s also rewarding.', 'learn;to learn;learning', 'to learn', ''),
(227, 'intermediate_exam', 'Could you tell me ___ the nearest post office is?', 'where;that where;that', 'where', ''),
(228, 'intermediate_exam', 'Despite ___ hard, he failed the exam.', 'studying;to study;he studied', 'studying', ''),
(229, 'intermediate_exam', 'I wish I ___ play the piano as well as you do.', 'can;could;might', 'could', ''),
(230, 'intermediate_exam', 'There aren\'t ___ seats left on the early train.', 'much;many;a lot', 'many', ''),
(231, 'intermediate_exam', 'The book ___ written by a famous author.', 'is;was;has been', 'was', ''),
(232, 'intermediate_exam', 'We saw a lot of interesting things ___ we were on holiday.', 'during;while;for', 'while', ''),
(233, 'intermediate_exam', 'You ___ to leave your bag unattended in the airport.', 'mustn\'t;don\'t have;shouldn\'t', 'mustn\'t', ''),
(234, 'intermediate_exam', 'She keeps ___ her keys and forgets where she puts them.', 'losing;to lose;lost', 'losing', ''),
(235, 'intermediate_exam', 'The higher you climb, the ___ the air gets.', 'colder;coldest;more cold', 'colder', ''),
(236, 'intermediate_exam', 'I asked him if he ___ coming to the meeting.', 'is;was;will be', 'was', ''),
(237, 'intermediate_exam', 'We need to talk ___ the plans for the upcoming event.', 'of;about;for', 'about', ''),
(238, 'intermediate_exam', 'The doctor advised me ___ smoking immediately.', 'to stop;stopping;stop', 'to stop', ''),
(239, 'intermediate_exam', 'By next month, I ___ in this company for ten years.', 'will work;will have worked;am working', 'will have worked', ''),
(240, 'intermediate_exam', 'He can\'t afford ___ a new car this year.', 'buy;buying;to buy', 'to buy', ''),
(241, 'intermediate_exam', 'The window ___ by a stone thrown by the children.', 'broke;was broken;has broke', 'was broken', ''),
(242, 'intermediate_exam', 'It took them a long time to get ___ the shock of the accident.', 'over;through;away', 'over', ''),
(243, 'intermediate_exam', 'Neither John ___ his sister are interested in attending the concert.', 'or;nor;and', 'nor', ''),
(244, 'intermediate_exam', 'If you heat water to $100^{circ}C$, it ___.', 'boil;boils;will boil', 'boils', ''),
(245, 'intermediate_exam', 'The reason ___ I left early was to avoid the traffic.', 'because;why;what', 'why', ''),
(246, 'intermediate_exam', 'That jacket is similar ___ the one I bought yesterday.', 'to;with;than', 'to', ''),
(247, 'intermediate_exam', 'I\'m not sure ___ she will accept the job offer.', 'if;that;what', 'if', ''),
(248, 'intermediate_exam', 'The old house, ___ roof was damaged, needed major repairs.', 'who;which;whose', 'whose', ''),
(249, 'intermediate_exam', 'There is ___ hope of finding survivors after such a long time.', 'little;a little;few', 'little', ''),
(250, 'intermediate_exam', 'I\'d rather you ___ that noisy music while I\'m studying.', 'didn\'t play;don\'t play;won\'t play', 'didn\'t play', ''),
(251, 'intermediate_exam', 'They are planning ___ a new business next year.', 'to open;opening;open', 'to open', ''),
(252, 'intermediate_exam', 'We must hurry, ___ we\'ll miss the train.', 'or;unless;and', 'or', ''),
(253, 'intermediate_exam', 'She is very good ___ persuading people to agree with her.', 'at;in;on', 'at', ''),
(254, 'intermediate_exam', 'He spends most of his free time ___ historical documentaries.', 'watch;watching;to watch', 'watching', ''),
(255, 'intermediate_exam', 'The party was a disaster. Almost ___ came.', 'nobody;anybody;somebody', 'nobody', ''),
(256, 'intermediate_exam', 'The problem has been completely ___ since the new system was implemented.', 'solved;solving;solve', 'solved', ''),
(257, 'intermediate_exam', 'They decided to call ___ the meeting due to low attendance.', 'off;up;out', 'off', ''),
(258, 'intermediate_exam', 'If I were you, I ___ accept that job offer immediately.', 'will;would;might', 'would', ''),
(259, 'intermediate_exam', 'She has difficulty ___ new people, as she is quite shy.', 'meet;to meet;meeting', 'meeting', ''),
(260, 'advanced_exam', 'If I ___ known about the meeting, I would have attended.', 'had;have;has', 'had', ''),
(261, 'advanced_exam', 'She suggested that he ___ more careful next time.', 'be;is;was', 'be', ''),
(262, 'advanced_exam', 'No sooner ___ he arrived than it started raining.', 'had;has;have', 'had', ''),
(263, 'advanced_exam', 'By the time we get there, the film ___ already started.', 'will have;will;has', 'will have', ''),
(264, 'advanced_exam', 'I wish I ___ how to play the piano.', 'knew;know;knows', 'knew', ''),
(265, 'advanced_exam', 'He acts as though he ___ everything.', 'knew;knows;has known', 'knew', ''),
(266, 'advanced_exam', 'She would have come if she ___ invited.', 'had been;was;has been', 'had been', ''),
(267, 'advanced_exam', 'They insisted that he ___ present for the discussion.', 'be;is;was', 'be', ''),
(268, 'advanced_exam', 'Hardly ___ the bell rung when the class began.', 'had;has;have', 'had', ''),
(269, 'advanced_exam', 'If it ___ for your help, I could not have finished.', 'had not been;was not;were not', 'had not been', ''),
(270, 'advanced_exam', 'It is high time you ___ to bed.', 'went;go;gone', 'went', ''),
(271, 'advanced_exam', 'I would rather you ___ me the truth.', 'told;tell;telling', 'told', ''),
(272, 'advanced_exam', 'She spoke to me as if she ___ my teacher.', 'were;was;is', 'were', ''),
(273, 'advanced_exam', 'Had I ___ the opportunity, I would have traveled more.', 'had;have;has', 'had', ''),
(274, 'advanced_exam', 'The manager demanded that the report ___ immediately.', 'be submitted;is submitted;was submitted', 'be submitted', ''),
(275, 'advanced_exam', 'If only he ___ earlier, none of this would have happened.', 'had arrived;arrived;arrives', 'had arrived', ''),
(276, 'advanced_exam', 'I would have helped you if I ___ about your problem.', 'had known;knew;know', 'had known', ''),
(277, 'advanced_exam', 'She behaves as though she ___ everything.', 'knows;knew;has known', 'knew', ''),
(278, 'advanced_exam', 'We wish the train ___ on time today.', 'would arrive;arrives;arrived', 'would arrive', ''),
(279, 'advanced_exam', 'He talks as though he ___ an expert.', 'were;was;is', 'were', ''),
(280, 'advanced_exam', 'They would rather we ___ the meeting until tomorrow.', 'postponed;postpone;had postponed', 'postponed', ''),
(281, 'advanced_exam', 'If you ___ harder, you would have passed.', 'had studied;studied;study', 'had studied', ''),
(282, 'advanced_exam', 'The report must ___ completed by Monday.', 'be;been;being', 'be', ''),
(283, 'advanced_exam', 'Had she ___ more careful, she would not have lost it.', 'been;be;was', 'been', ''),
(284, 'advanced_exam', 'It is necessary that he ___ the form before leaving.', 'fill;fills;filled', 'fill', ''),
(285, 'advanced_exam', 'She insisted that the work ___ finished today.', 'be;is;was', 'be', ''),
(286, 'advanced_exam', 'I wish it ___ snow so much every winter.', 'did not;does not;had not', 'did not', ''),
(287, 'advanced_exam', 'If I ___ you, I would take the offer.', 'were;was;am', 'were', ''),
(288, 'advanced_exam', 'The committee recommended that the proposal ___ reconsidered.', 'be;is;was', 'be', ''),
(289, 'advanced_exam', 'He looked as though he ___ something important.', 'had lost;lost;loses', 'had lost', ''),
(290, 'advanced_exam', 'By next week, they ___ completed the project.', 'will have;have;will', 'will have', ''),
(291, 'advanced_exam', 'It was essential that she ___ informed immediately.', 'be;was;is', 'be', ''),
(292, 'advanced_exam', 'We would have arrived earlier if we ___ the shortcut.', 'had taken;took;take', 'had taken', ''),
(293, 'advanced_exam', 'He said he would rather we ___ tomorrow instead.', 'met;meet;had met', 'met', ''),
(294, 'advanced_exam', 'No sooner ___ we sat down than the show began.', 'had;has;have', 'had', ''),
(295, 'advanced_exam', 'If it ___ raining, we could go out.', 'stopped;stop;had stopped', 'stopped', ''),
(296, 'advanced_exam', 'I wish he ___ so rude to everyone.', 'were not;was not;is not', 'were not', ''),
(297, 'advanced_exam', 'If only she ___ the truth before it was too late.', 'had told;told;tells', 'had told', ''),
(298, 'advanced_exam', 'She speaks English as though she ___ in London.', 'had lived;lived;lives', 'had lived', ''),
(299, 'advanced_exam', 'It is crucial that the students ___ prepared for the exam.', 'be;are;were', 'be', ''),
(300, 'advanced_exam', 'I would rather you ___ not smoke here.', 'did;do;had', 'did', ''),
(301, 'advanced_exam', 'Had they ___ earlier, they would have avoided traffic.', 'left;leave;leaves', 'left', ''),
(302, 'advanced_exam', 'If you ___ me earlier, I could have helped.', 'had called;called;call', 'had called', ''),
(303, 'advanced_exam', 'He behaves as if he ___ the boss.', 'were;was;is', 'were', ''),
(304, 'advanced_exam', 'It\'s about time you ___ that report.', 'finished;finish;finishes', 'finished', ''),
(305, 'advanced_exam', 'If the weather ___ better, we might have gone hiking.', 'had been;was;is', 'had been', ''),
(306, 'advanced_exam', 'She looked as if she ___ crying.', 'had been;has been;was', 'had been', ''),
(307, 'advanced_exam', 'The teacher required that each student ___ a notebook.', 'have;has;had', 'have', ''),
(308, 'advanced_exam', 'Were I ___ the choice, I would decline.', 'given;give;gives', 'given', ''),
(309, 'advanced_exam', 'If we ___ earlier, we wouldn\'t have missed the train.', 'had left;left;leave', 'had left', '');

-- --------------------------------------------------------

--
-- Table structure for table `path_info`
--

CREATE TABLE `path_info` (
  `id` int(3) NOT NULL,
  `level` varchar(12) NOT NULL,
  `level_type` varchar(13) NOT NULL,
  `info` varchar(5000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `path_info`
--

INSERT INTO `path_info` (`id`, `level`, `level_type`, `info`) VALUES
(1, 'beginner', 'spelling', '<h2>\nDifficulties Faced by Filipinos in English Spelling\n</h2>\n<hr>\n<p>\n  Filipinos generally have high English proficiency, but several factors rooted in the structure of their native languages (like Tagalog or Cebuano) and the nature of English spelling itself contribute to specific difficulties:\n</p>\n\n<h3>\n  Phoneme-Grapheme Inconsistency\n</h3>\n<ul>\n  <li>\n    <strong>Spelling vs. Pronunciation:</strong> The most significant difficulty stems from the fact that Filipino languages are highly \n    <strong>phonetic</strong> \n    (one sound, one letter). In contrast, English has a very \n    <strong>inconsistent</strong> \n    relationship between sounds (phonemes) and letters (graphemes). Filipinos often attempt to spell English words exactly as they are pronounced.\n  </li>\n  <li>\n    <strong>Examples of Inconsistency:</strong> Words containing silent letters (e.g., \n    <em>knowledge</em>, \n    <em>pneumonia</em>) or words with multiple ways to spell the same sound (e.g., the /f/ sound in \n    <em>fun</em> \n    vs. \n    <em>phone</em> \n    vs. \n    <em>tough</em>).\n  </li>\n</ul>\n\n<h3>\n  Influence of the Native Phonology\n</h3>\n<ul>\n  <li>\n    <strong>Vowel System Differences:</strong> Filipino languages have fewer vowel sounds (typically 3 to 5) than English (which has 12 pure vowels and several diphthongs). This simplification can lead to confusion when distinguishing and spelling English vowels, especially those that sound similar but are spelled differently (e.g., \n    <em>meet</em> \n    vs. \n    <em>meat</em>; \n    <em>full</em> \n    vs. \n    <em>fool</em>).\n  </li>\n  <li>\n    <strong>Diphthongs and Digraphs:</strong> Difficulty mastering English vowel digraphs (like \n    <em>ie</em> \n    or \n    <em>ou</em>) and diphthongs, which don\'t map neatly onto native sound systems.\n  </li>\n</ul>\n\n<h3>\n  Consonant Cluster Simplification\n</h3>\n<ul>\n  <li>\n    <strong>Epenthesis:</strong> In their native languages, Filipinos avoid complex consonant clusters at the beginning or end of syllables. When encountering English words with clusters (e.g., \n    <em>street</em>, \n    <em>school</em>), they often add an extra vowel sound (epenthesis) during pronunciation, which can incorrectly influence the spelling (e.g., writing *istreet* or *ischool*).\n  </li>\n</ul>\n<hr>\n<h3>\n  Sources\n</h3>\n<p>\n  <small>\n    * Bernardo, A. B. I. (2005). English in the Philippines: A brief history and some current challenges. \n    <em>World Englishes</em>, 24(1), 43-52.\n  </small>\n  <br>\n  <small>\n    * Bautista, M. L. S. (2000). \n    <em>Defining Filipino English: Features and functions</em>. De La Salle University Press.\n  </small>\n  <br>\n  <small>\n    * Tupas, R. (2006). The politics of \"Philippine English\": Linguistic colonialism and the \"failure\" of English in the Philippines. \n    <em>World Englishes</em>, 25(3-4), 479-490.\n  </small>\n</p>'),
(2, 'beginner', 'sentence_form', '<h2> Difficulties Faced by Filipino Beginners in Forming Sentences in the Correct Order </h2> <hr> <p>   Filipino beginners in English often struggle with forming sentences in the correct syntactic order. This difficulty arises primarily from differences in sentence structure between English and Philippine languages, limited exposure to natural English syntax, and the tendency to directly translate ideas from the native language into English. These challenges can lead to confusion in arranging words properly within sentences. </p>  <h3>   Influence of Native Word Order </h3> <ul>   <li>     <strong>Verb-Initial Structures:</strong> Many Philippine languages, such as Tagalog and Cebuano, commonly follow a <em>Verb–Subject–Object (VSO)</em> or <em>Verb–Object–Subject (VOS)</em> order. English, however, uses a <em>Subject–Verb–Object (SVO)</em> pattern. Beginners often transfer their native syntax to English, producing sentences like <em>Is eating Maria rice</em> instead of <em>Maria is eating rice</em>.   </li>   <li>     <strong>Topic-Comment Sentences:</strong> Filipino languages are often <em>topic-prominent</em>, meaning that the topic of the sentence (what is being talked about) comes first, regardless of grammatical role. This may result in English sentences that sound disordered, such as <em>The mango, she ate</em> instead of <em>She ate the mango</em>.   </li> </ul>  <h3>   Confusion with Modifiers and Adjectives </h3> <ul>   <li>     <strong>Adjective Placement:</strong> In Filipino languages, adjectives typically follow the noun (e.g., <em>bahay malaki</em> = “house big”). Beginners may apply this pattern to English and produce phrases like <em>house big</em> instead of <em>big house</em>.   </li>   <li>     <strong>Misplaced Adverbs:</strong> Learners sometimes place adverbs in unnatural positions because of literal translation or uncertainty (e.g., <em>I eat always rice</em> instead of <em>I always eat rice</em>).   </li> </ul>  <h3>   Difficulties with Questions and Negatives </h3> <ul>   <li>     <strong>Auxiliary Verbs in Questions:</strong> Forming English questions requires auxiliary verbs and subject-verb inversion (e.g., <em>Do you like apples?</em>). Since Philippine languages don’t use this structure, beginners might say <em>You like apples?</em> instead.   </li>   <li>     <strong>Word Order in Negatives:</strong> English negatives need the auxiliary <em>do</em> in simple tenses (<em>I do not know</em>), but Filipino learners often omit it, creating sentences like <em>I not know</em> or <em>I don’t knows</em>.   </li> </ul>  <h3>   Limited Awareness of Sentence Patterns </h3> <ul>   <li>     <strong>Lack of Understanding of Basic Sentence Frames:</strong> Beginners may not yet internalize common English structures such as <em>There is/are</em>, <em>It is...</em>, or <em>Subject + Verb + Complement</em>. This often leads to incomplete or fragmentary sentences (e.g., <em>Is raining</em> instead of <em>It is raining</em>).   </li>   <li>     <strong>Dependence on Translation:</strong> Many students translate from Filipino word-for-word rather than constructing sentences based on English grammatical rules, which results in unnatural or reversed word order.   </li> </ul>  <h3>   Lack of Confidence and Practice </h3> <ul>   <li>     <strong>Fear of Making Mistakes:</strong> Because sentence formation errors are easily noticed, beginners often hesitate to speak or write, further limiting opportunities to practice proper word order.   </li>   <li>     <strong>Limited Input from Natural English:</strong> Exposure to correct English patterns through media or conversation helps build intuition for syntax, but many learners rely mainly on textbook English, which slows syntactic development.   </li> </ul>  <hr> <h3>   Sources </h3> <p>   <small>     * Bautista, M. L. S. (2004). The grammar of Philippine English. In M. L. S. Bautista & G. O. Bolton (Eds.),      <em>Philippine English: Linguistic and literary perspectives</em> (pp. 228–245). Hong Kong University Press.   </small>   <br>   <small>     * Bernardo, A. B. I. (2008). English in Philippine education: Issues and concerns.      <em>Asian Englishes</em>, 11(1), 36–48.   </small>   <br>   <small>     * Llamzon, T. A. (1997). The phonology and syntax of Philippine English.      <em>Philippine Journal of Linguistics</em>, 28(1), 1–19.   </small>   <br>   <small>     * Dayag, D. T. (2004). Patterns of language transfer in Philippine English syntax.      <em>World Englishes</em>, 23(4), 567–582.   </small> </p>'),
(3, 'beginner', 'grammar', '<h2>\nDifficulties Faced by Filipino Beginners in English Grammar\n</h2>\n<hr>\n<p>\n  Filipino beginners in learning English grammar face several challenges that stem from structural differences between English and local Philippine languages, limited exposure to authentic English usage, and varying proficiency levels in foundational grammar concepts. These difficulties often affect sentence construction, verb usage, and the understanding of grammatical relationships.\n</p>\n\n<h3>\n  Differences Between Filipino and English Grammar Systems\n</h3>\n<ul>\n  <li>\n    <strong>Absence of Verb Conjugation for Tense in Filipino:</strong> Tagalog and other Philippine languages use aspect rather than tense to indicate time. As a result, beginners may find it difficult to understand English verb tenses and may produce sentences such as <em>I eat yesterday</em> instead of <em>I ate yesterday</em>.\n  </li>\n  <li>\n    <strong>Lack of Subject-Verb Agreement Markers:</strong> In Filipino, verbs do not change according to the subject. Beginners often omit the <em>-s</em> in third-person singular forms (e.g., <em>He walk to school</em> instead of <em>He walks to school</em>).\n  </li>\n</ul>\n\n<h3>\n  Confusion with Articles and Determiners\n</h3>\n<ul>\n  <li>\n    <strong>No Direct Equivalent in Native Languages:</strong> Since Philippine languages generally do not use articles like <em>a</em>, <em>an</em>, or <em>the</em>, beginners may omit them entirely or overuse them in inappropriate contexts (e.g., <em>I have the pencil</em> when referring to any pencil).\n  </li>\n  <li>\n    <strong>Difficulty Understanding Specific vs. General Reference:</strong> Learners may struggle to distinguish when a noun refers to something general (<em>a dog</em>) or specific (<em>the dog</em>), leading to inconsistent article use.\n  </li>\n</ul>\n\n<h3>\n  Tense and Aspect Confusion\n</h3>\n<ul>\n  <li>\n    <strong>Limited Tense Awareness:</strong> Beginners often rely on context or time markers (e.g., “yesterday,” “tomorrow”) instead of grammatical tense, resulting in errors such as <em>I am go yesterday</em> or <em>I will went there</em>.\n  </li>\n  <li>\n    <strong>Overgeneralization of Forms:</strong> Learners may apply a single tense form across contexts due to lack of understanding of aspect (e.g., using <em>I am eating</em> for both habitual and ongoing actions).\n  </li>\n</ul>\n\n<h3>\n  Problems with Sentence Construction\n</h3>\n<ul>\n  <li>\n    <strong>Word Order Transfer:</strong> Filipino languages often have flexible word order, while English requires a fixed <em>Subject–Verb–Object</em> structure. Beginners may produce sentences such as <em>Is playing the boy</em> instead of <em>The boy is playing</em>.\n  </li>\n  <li>\n    <strong>Incomplete Sentences:</strong> Many beginners omit essential sentence elements like subjects or verbs, resulting in fragments (e.g., <em>Going to school</em> instead of <em>I am going to school</em>).\n  </li>\n</ul>\n\n<h3>\n  Prepositions and Pronouns\n</h3>\n<ul>\n  <li>\n    <strong>Preposition Confusion:</strong> Direct translations from Filipino often cause errors in preposition use (e.g., <em>in the bus</em> instead of <em>on the bus</em> or <em>discuss about</em> instead of <em>discuss</em>).\n  </li>\n  <li>\n    <strong>Pronoun Reference Errors:</strong> Since gendered pronouns (<em>he</em>, <em>she</em>) do not exist in Filipino, beginners frequently confuse them (e.g., <em>He is my mother</em>).\n  </li>\n</ul>\n\n<h3>\n  Affective and Environmental Factors\n</h3>\n<ul>\n  <li>\n    <strong>Fear of Correction:</strong> Many Filipino beginners hesitate to speak or write in English for fear of grammatical mistakes, which slows their development of accuracy.\n  </li>\n  <li>\n    <strong>Limited Authentic Input:</strong> English grammar is often learned through memorization rather than exposure to natural use, leading to difficulty applying rules in real communication.\n  </li>\n</ul>\n\n<hr>\n<h3>\n  Sources\n</h3>\n<p>\n  <small>\n    * Bautista, M. L. S. (2004). The grammar of Philippine English. In M. L. S. Bautista & G. O. Bolton (Eds.), \n    <em>Philippine English: Linguistic and literary perspectives</em> (pp. 228–245). Hong Kong University Press.\n  </small>\n  <br>\n  <small>\n    * Bernardo, A. B. I. (2008). English in Philippine education: Issues and concerns. \n    <em>Asian Englishes</em>, 11(1), 36–48.\n  </small>\n  <br>\n  <small>\n    * Dayag, D. T. (2007). The discourse of English language education in the Philippines: A reflection of current theories and practices. \n    <em>Asian Englishes</em>, 10(1), 48–66.\n  </small>\n  <br>\n  <small>\n    * Gonzalez, A. (1997). The lexical and grammatical features of Philippine English. \n    <em>Asian Englishes</em>, 1(1), 40–51.\n  </small>\n</p>'),
(4, 'intermediate', 'spelling', '<h2>\nDifficulties Faced by Filipino Intermediate Learners in English Spelling\n</h2>\n<hr>\n<p>\n  Filipino intermediate learners of English show improved vocabulary and writing skills, yet many continue to make spelling errors. These difficulties result from the irregular sound–letter relationship in English, differences in Filipino phonology, and limited attention to spelling in higher language instruction. While learners often recognize correct spellings when reading, they may still produce inaccurate forms in writing.\n</p>\n\n<h3>\n  Phoneme–Grapheme Irregularities\n</h3>\n<ul>\n  <li>\n    <strong>Sound–Letter Mismatch:</strong> English spelling is inconsistent, unlike Tagalog’s phonetic system. Learners tend to spell words as they sound, producing errors like <em>nife</em> for <em>knife</em> or <em>tuff</em> for <em>tough</em>.\n  </li>\n  <li>\n    <strong>Homophones and Silent Letters:</strong> Words such as <em>their</em>, <em>there</em>, and <em>they’re</em> or those with silent letters (<em>honest</em>, <em>receipt</em>) often confuse learners.\n  </li>\n</ul>\n\n<h3>\n  Influence of Filipino Phonology\n</h3>\n<ul>\n  <li>\n    <strong>Limited Vowel Distinctions:</strong> Filipino languages have fewer vowel sounds, making words like <em>ship</em> and <em>sheep</em> sound similar, which affects spelling accuracy.\n  </li>\n  <li>\n    <strong>Consonant Substitution:</strong> English sounds absent in Filipino, such as /f/, /v/, and /θ/, may be replaced with local equivalents, leading to errors like <em>pipty</em> for <em>fifty</em>.\n  </li>\n</ul>\n\n<h3>\n  Morphological and Rule-Based Confusion\n</h3>\n<ul>\n  <li>\n    <strong>Inflectional Endings:</strong> Learners struggle with irregular plurals and past tense forms (<em>gooses</em> for <em>geese</em>, <em>tryed</em> for <em>tried</em>).\n  </li>\n  <li>\n    <strong>Suffix Changes:</strong> Adding <em>-ed</em> or <em>-ing</em> often causes confusion with doubling or dropping letters (<em>makeing</em> for <em>making</em>, <em>stoping</em> for <em>stopping</em>).\n  </li>\n</ul>\n\n<h3>\n  Exposure and Usage Factors\n</h3>\n<ul>\n  <li>\n    <strong>Influence of Informal Writing:</strong> Frequent use of text and social media English (<em>pls</em>, <em>bcoz</em>) reinforces nonstandard spelling habits.\n  </li>\n  <li>\n    <strong>Dependence on Spell Checkers:</strong> Many learners rely on digital correction tools instead of practicing manual spelling, limiting retention.\n  </li>\n</ul>\n\n<h3>\n  British and American Spelling Variants\n</h3>\n<ul>\n  <li>\n    <strong>Mixed Exposure:</strong> Learners encounter both British and American spellings (<em>color</em> vs. <em>colour</em>), often within the same materials.\n  </li>\n  <li>\n    <strong>Lack of Consistency:</strong> Without clear instruction on which standard to follow, students alternate between forms, reducing spelling accuracy.\n  </li>\n</ul>\n\n<h3>\n  Limited Practice and Reinforcement\n</h3>\n<ul>\n  <li>\n    <strong>Reduced Focus in Education:</strong> At intermediate levels, attention shifts to composition and comprehension, leaving spelling underemphasized.\n  </li>\n  <li>\n    <strong>Reading–Writing Gap:</strong> Learners may recognize correct spellings but fail to reproduce them accurately due to minimal writing practice.\n  </li>\n</ul>\n\n<hr>\n<h3>\n  Sources\n</h3>\n<p>\n  <small>\n    * Bernardo, A. B. I. (2005). English in the Philippines: A brief history and some current challenges. \n    <em>World Englishes</em>, 24(1), 43–52.\n  </small>\n  <br>\n  <small>\n    * Bautista, M. L. S. (2000). \n    <em>Defining Filipino English: Features and functions</em>. De La Salle University Press.\n  </small>\n  <br>\n  <small>\n    * Tupas, R. (2006). The politics of \"Philippine English\": Linguistic colonialism and the \"failure\" of English in the Philippines. \n    <em>World Englishes</em>, 25(3–4), 479–490.\n  </small>\n</p>'),
(5, 'intermediate', 'sentence_form', '<h2> Difficulties Faced by Filipino Intermediate Learners in Forming Proper English Sentences </h2> <hr> <p>   At the intermediate stage, Filipino learners of English can express complex ideas but often produce sentences that contain structural or grammatical errors. These difficulties arise from differences between English and local language patterns, interference from direct translation, and limited mastery of more advanced sentence structures. As learners progress, errors shift from basic grammar to issues involving coherence, subordination, and word order. </p>  <h3>   Influence of Native Syntax </h3> <ul>   <li>     <strong>Topic-Prominent Order:</strong> Philippine languages often emphasize the topic before the subject or verb. This transfer leads to sentences like <em>The mango, I ate</em> instead of <em>I ate the mango</em>.   </li>   <li>     <strong>Verb Placement:</strong> Tagalog frequently begins with the verb (<em>Kumain siya ng tinapay</em> – “Ate she bread”), which may cause inversions such as <em>Ate she bread</em> in English.   </li> </ul>  <h3>   Sentence Structure and Complexity </h3> <ul>   <li>     <strong>Run-On Sentences:</strong> Intermediate learners often join clauses without proper conjunctions or punctuation (e.g., <em>I study hard I want to pass</em>).   </li>   <li>     <strong>Fragmented Sentences:</strong> Learners may omit key elements, producing incomplete ideas such as <em>Because I am tired</em> without a main clause.   </li> </ul>  <h3>   Misuse of Conjunctions and Connectors </h3> <ul>   <li>     <strong>Overuse of Basic Linkers:</strong> Words like <em>and</em> or <em>but</em> are used excessively, while subordinators like <em>although</em>, <em>unless</em>, and <em>despite</em> are underused, limiting sentence variety.   </li>   <li>     <strong>Confusion Between Logical Relationships:</strong> Learners may use incorrect connectors (e.g., <em>because</em> instead of <em>so</em>, or <em>although</em> instead of <em>however</em>), affecting meaning clarity.   </li> </ul>  <h3>   Tense Consistency and Agreement </h3> <ul>   <li>     <strong>Mixed Verb Tenses:</strong> Learners sometimes shift tenses within a sentence (e.g., <em>I was happy because he gives me food</em>).   </li>   <li>     <strong>Subject–Verb Agreement:</strong> Errors like <em>They goes</em> or <em>He play</em> persist, especially when complex phrases separate subject and verb.   </li> </ul>  <h3>   Word Order and Modifier Placement </h3> <ul>   <li>     <strong>Misplaced Modifiers:</strong> Adverbs may appear in awkward positions (<em>I eat always rice</em> instead of <em>I always eat rice</em>).   </li>   <li>     <strong>Adjective Position:</strong> Because adjectives follow nouns in Filipino, learners may say <em>house big</em> rather than <em>big house</em>.   </li> </ul>  <h3>   Limited Mastery of Complex Sentences </h3> <ul>   <li>     <strong>Overreliance on Simple Sentences:</strong> Learners tend to write short, separate statements (<em>I woke up. I ate breakfast. I went to work.</em>) instead of using subordination or coordination.   </li>   <li>     <strong>Errors with Relative Clauses:</strong> Phrases like <em>The man which I saw</em> instead of <em>The man whom I saw</em> show partial control of advanced grammar.   </li> </ul>  <h3>   Cognitive and Affective Factors </h3> <ul>   <li>     <strong>Translation Dependence:</strong> Learners often construct sentences by translating from Filipino, resulting in unnatural order and phrasing.   </li>   <li>     <strong>Lack of Confidence:</strong> Awareness of grammatical mistakes can make learners hesitant, reducing fluency and sentence complexity.   </li> </ul>  <hr> <h3>   Sources </h3> <p>   <small>     * Bautista, M. L. S. (2004). The grammar of Philippine English. In M. L. S. Bautista & G. O. Bolton (Eds.),      <em>Philippine English: Linguistic and literary perspectives</em> (pp. 228–245). Hong Kong University Press.   </small>   <br>   <small>     * Dayag, D. T. (2004). Patterns of language transfer in Philippine English syntax.      <em>World Englishes</em>, 23(4), 567–582.   </small>   <br>   <small>     * Bernardo, A. B. I. (2008). English in Philippine education: Issues and concerns.      <em>Asian Englishes</em>, 11(1), 36–48.   </small>   <br>   <small>     * Gonzalez, A. (1997). The lexical and grammatical features of Philippine English.      <em>Asian Englishes</em>, 1(1), 40–51.   </small> </p>'),
(6, 'intermediate', 'grammar', '<h2> Difficulties Faced by Filipinos in Intermediate-Level English Grammar </h2> <hr> <p>   While Filipinos generally demonstrate strong English proficiency due to the country\'s bilingual education system, intermediate-level learners often face persistent grammatical difficulties. These challenges arise from structural differences between English and Philippine languages, transfer from local linguistic patterns, and limited exposure to advanced English usage in everyday contexts. </p>  <h3>   Subject-Verb Agreement </h3> <ul>   <li>     <strong>Absence of Verb Inflection in Native Languages:</strong> Many Philippine languages, including Tagalog, do not mark verbs for number or person. As a result, Filipino learners may omit or misuse third-person singular <em>-s</em> in English verbs (e.g., saying <em>She go to school</em> instead of <em>She goes to school</em>).   </li>   <li>     <strong>Plural and Collective Confusion:</strong> Learners may also confuse agreement when subjects appear complex or include quantifiers (e.g., <em>Everyone have problems</em> instead of <em>Everyone has problems</em>).   </li> </ul>  <h3>   Tense and Aspect Usage </h3> <ul>   <li>     <strong>Limited Tense Distinctions in Filipino Languages:</strong> Philippine languages express time primarily through adverbs or context rather than verb inflection. Consequently, learners may struggle with English tense consistency, overusing the simple present or past instead of progressive or perfect aspects (e.g., <em>I already eat</em> for <em>I have already eaten</em>).   </li>   <li>     <strong>Confusion with Perfect Tenses:</strong> Intermediate learners often avoid using the present perfect and past perfect due to their complexity and lack of direct equivalents in Tagalog and Cebuano.   </li> </ul>  <h3>   Article Usage </h3> <ul>   <li>     <strong>Articles Not Present in Local Languages:</strong> Because Tagalog and most Philippine languages lack articles, Filipino learners frequently omit <em>a</em>, <em>an</em>, and <em>the</em> or use them incorrectly (e.g., <em>I have car</em> or <em>The love is important</em>).   </li>   <li>     <strong>Difficulty Distinguishing Definiteness:</strong> Learners may find it challenging to determine when a noun is specific or general, which affects accurate article use.   </li> </ul>  <h3>   Preposition Choice </h3> <ul>   <li>     <strong>Direct Translation from Filipino:</strong> Many prepositional errors stem from translating native structures word-for-word (e.g., <em>discuss about</em> instead of <em>discuss</em>, <em>in the bus</em> instead of <em>on the bus</em>).   </li>   <li>     <strong>Context-Dependent Meanings:</strong> English prepositions have multiple meanings depending on context, making mastery difficult even for intermediate learners.   </li> </ul>  <h3>   Word Order and Sentence Structure </h3> <ul>   <li>     <strong>Influence of Topic-Prominent Native Syntax:</strong> Philippine languages often follow a topic-comment or verb-initial structure (e.g., <em>Kumain siya ng mangga</em> literally “Ate she mango”). This can lead to non-standard English sentence constructions (e.g., <em>Ate she a mango</em> or <em>Is studying he now</em>).   </li>   <li>     <strong>Complex Sentences:</strong> Intermediate learners may avoid or misuse subordinate clauses due to uncertainty about conjunctions and clause order.   </li> </ul>  <hr> <h3>   Sources </h3> <p>   <small>     * Bernardo, A. B. I. (2008). English in Philippine education: Issues and concerns.      <em>Asian Englishes</em>, 11(1), 36–48.   </small>   <br>   <small>     * Bautista, M. L. S. (2004). The grammar of Philippine English. In M. L. S. Bautista & G. O. Bolton (Eds.),      <em>Philippine English: Linguistic and literary perspectives</em> (pp. 228–245). Hong Kong University Press.   </small>   <br>   <small>     * Dayag, D. T. (2004). Patterns of tense, aspect, and modality in Philippine English.      <em>World Englishes</em>, 23(4), 533–545.   </small>   <br>   <small>     * Gonzales, A. (1997). The lexical and grammatical features of Philippine English.      <em>Asian Englishes</em>, 1(1), 40–51.   </small> </p>'),
(7, 'intermediate', 'pronunciation', '<h2> Difficulties Faced by Filipino Intermediate Learners in English Pronunciation </h2> <hr> <p>   Filipino learners of English at the intermediate level often have good vocabulary and grammar skills but continue to struggle with pronunciation. These difficulties arise from the influence of native language phonology, the mismatch between English spelling and sounds, and the complex vowel and consonant system of English. </p>  <h3>   Vowel Sounds </h3> <ul>   <li>     <strong>Limited vowel inventory:</strong> Filipino languages typically have 3–5 vowel sounds, while English has around 12 pure vowels and several diphthongs. Intermediate learners may confuse similar vowels (e.g., <em>ship</em> vs. <em>sheep</em>, <em>full</em> vs. <em>fool</em>), affecting intelligibility.   </li>   <li>     <strong>Diphthong pronunciation:</strong> English diphthongs like /aɪ/ in <em>time</em> or /eɪ/ in <em>face</em> may be simplified or altered to single vowels, causing accent interference.   </li> </ul>  <h3>   Consonant Challenges </h3> <ul>   <li>     <strong>Word-initial clusters:</strong> Filipinos often insert a vowel to break up difficult clusters (epenthesis), turning <em>street</em> into <em>istreet</em>, which may persist in speech.   </li>   <li>     <strong>Final consonants:</strong> English words ending with consonant clusters (e.g., <em>asked</em>, <em>helped</em>) may lose the final consonant or cluster, affecting pronunciation and comprehension.   </li>   <li>     <strong>Th-sounds (/θ/ and /ð/):</strong> These are often replaced with /t/, /d/, /s/, or /d/ (e.g., <em>think</em> → <em>tink</em>; <em>this</em> → <em>dis</em>), which can cause confusion in communication.   </li> </ul>  <h3>   Stress, Rhythm, and Intonation </h3> <ul>   <li>     <strong>Syllable-timed rhythm:</strong> Filipino learners tend to give equal stress to each syllable, whereas English is stress-timed. This can make speech sound choppy and unnatural.   </li>   <li>     <strong>Word stress errors:</strong> Incorrect placement of primary stress in words (e.g., <em>record</em> noun vs. verb) can change meaning or hinder understanding.   </li>   <li>     <strong>Intonation patterns:</strong> Rising and falling intonation patterns in questions, statements, and emphasis may be flattened or misused, affecting pragmatic meaning.   </li> </ul>  <h3>   Influence of Orthography </h3> <ul>   <li>     <strong>Spelling-pronunciation mismatch:</strong> Filipino learners may pronounce words as they are spelled (e.g., <em>colonel</em> → /ˈko-lo-nel/), reflecting difficulties in decoding English irregularities.   </li>   <li>     <strong>Silent letters:</strong> Words with silent letters (e.g., <em>knife</em>, <em>honest</em>) are often mispronounced by pronouncing all letters.   </li> </ul>  <h3>   Sources </h3> <p>   <small>     * Bautista, M. L. S. (2004). Kilag, O. K. T., & Engbino, V. A. (2023).<em>Filipino senior high school students’ pronunciation in English.</em> International Journal of Social Science Research, 12(3), 45–58.</small>   <br>   <small>     * Li, X., & Chen, Y. (2020).<em>Intelligibility and comprehensibility of the Filipino English accent to Hong Kong English speakers.</em>3L: Language, Linguistics, Literature, 26(2), 101–118.</small>   <br>   <small>     * Melienia, R. (2021).<em>Vowel pronunciation of English words by Filipino speakers in the “Everglow” short movie.</em>Dinamika: Jurnal Ilmiah, 17(1), 12–25.</small> </p>'),
(8, 'advanced', 'spelling', '<h2> Difficulties Faced by Filipino Advanced Learners in English Spelling </h2> <hr> <p>   Even at advanced levels, Filipino users of English may experience occasional spelling errors, especially with less common or morphologically complex words. These challenges are less about basic phonetic confusion and more about inconsistency in English orthography, exposure to mixed English varieties, and the influence of digital writing practices. Advanced learners usually understand spelling rules but struggle with exceptions and contextual consistency. </p>  <h3>   Irregularity and Exception-Based Spelling </h3> <ul>   <li>     <strong>Unpredictable Rules:</strong> Advanced learners may still make slips with irregular patterns (<em>accommodate</em>, <em>recommend</em>, <em>independent</em>) where double letters and vowel combinations are inconsistent.   </li>   <li>     <strong>Silent and Shifting Letters:</strong> Words such as <em>subtle</em>, <em>debt</em>, and <em>island</em> remain problematic because pronunciation offers no clue to spelling.   </li> </ul>  <h3>   Morphological and Derivational Complexity </h3> <ul>   <li>     <strong>Derived Forms:</strong> Learners sometimes overgeneralize root-based spellings when adding suffixes, producing forms like <em>happinesss</em> or <em>occurence</em> instead of <em>happiness</em> and <em>occurrence</em>.   </li>   <li>     <strong>Foreign Borrowings:</strong> Advanced users encounter difficulty spelling words of Greek, Latin, or French origin (<em>rendezvous</em>, <em>liaison</em>, <em>conscience</em>), which deviate from typical English patterns.   </li> </ul>  <h3>   Influence of Varieties of English </h3> <ul>   <li>     <strong>British vs. American Exposure:</strong> Filipinos are exposed to both systems in media and education. This dual exposure causes inconsistent spelling habits (<em>organize</em> vs. <em>organise</em>, <em>defense</em> vs. <em>defence</em>).   </li>   <li>     <strong>Institutional Inconsistency:</strong> Schools, publishers, and workplaces may switch between standards, preventing learners from adopting a single, consistent system.   </li> </ul>  <h3>   Cognitive and Performance Factors </h3> <ul>   <li>     <strong>Autocorrect Reliance:</strong> Frequent computer or phone use leads many advanced learners to depend on spell-checkers, weakening recall of less common or technical spellings.   </li>   <li>     <strong>Speed over Accuracy:</strong> In professional or academic contexts, focus on content sometimes overrides attention to orthographic precision.   </li> </ul>  <h3>   Lexical and Disciplinary Vocabulary </h3> <ul>   <li>     <strong>Specialized Terminology:</strong> Advanced learners encounter field-specific words (e.g., <em>archaeology</em>, <em>bureaucracy</em>, <em>psychology</em>) that involve unusual or foreign spellings.   </li>   <li>     <strong>Visual Similarity Errors:</strong> Some learners confuse visually similar words (<em>affect</em> vs. <em>effect</em>, <em>loose</em> vs. <em>lose</em>) due to rapid writing or proofreading oversight.   </li> </ul>  <h3>   Cultural and Linguistic Interference </h3> <ul>   <li>     <strong>Taglish and Code-Switching:</strong> The blending of Tagalog and English in everyday writing exposes learners to hybrid or phonetic spellings (<em>syempre</em> for <em>surely</em>, <em>okie</em> for <em>okay</em>), influencing informal habits.   </li>   <li>     <strong>Borrowed English Words in Filipino:</strong> Words integrated into Filipino (e.g., <em>kompyuter</em>, <em>iskul</em>) reinforce phonetic spelling tendencies outside academic contexts.   </li> </ul>  <hr> <h3>   Sources </h3> <p>   <small>     * Bautista, M. L. S. (2004). The grammar of Philippine English. In M. L. S. Bautista & G. O. Bolton (Eds.),      <em>Philippine English: Linguistic and literary perspectives</em> (pp. 228–245). Hong Kong University Press.   </small>   <br>   <small>     * Bernardo, A. B. I. (2008). English in Philippine education: Issues and concerns.      <em>Asian Englishes</em>, 11(1), 36–48.   </small>   <br>   <small>     * Dayag, D. T. (2004). Patterns of language transfer in Philippine English orthography.      <em>Asian Englishes</em>, 7(2), 32–46.   </small>   <br>   <small>     * Tupas, R. (2015). Inequalities of multilingualism: Challenges to English education in the Philippines.      <em>Language and Education</em>, 29(2), 112–124.   </small> </p>'),
(9, 'advanced', 'sentence_form', '<h2> Difficulties Faced by Filipino Advanced Learners in Forming Proper English Sentences </h2> <hr> <p>   Even advanced Filipino learners of English still encounter challenges when constructing complex, well‑formed sentences. These issues are less about basic grammar and more about subtle syntactic control, lexical cohesion, and discourse organization. These difficulties stem from native‑language influence, limited exposure to high‑level sentence patterns, and the cognitive load of managing multiple linguistic demands. </p>  <h3>   Complex Sentence Structures and Subordination </h3> <ul>   <li>     <strong>Under‑use of subordinate clauses:</strong> Advanced learners may rely on simple sentence patterns instead of embedding clauses (e.g., preferring “I finished the report. I submitted it.” rather than “Having finished the report, I submitted it immediately.”). Research shows that many students struggle with sentence complexity in academic writing. :contentReference[oaicite:0]{index=0}   </li>   <li>     <strong>Errors in clause linkage and coherence:</strong> Learners may misuse connectors or fail to integrate clauses properly, yielding disjointed sentences and reduced readability. :contentReference[oaicite:1]{index=1}   </li> </ul>  <h3>   Lexical and Collocational Precision </h3> <ul>   <li>     <strong>Limited vocabulary for advanced discourse:</strong> Even at higher proficiency, learners may struggle to select appropriate lexical choices or collocations, which affects sentence fluency and style. :contentReference[oaicite:2]{index=2}   </li>   <li>     <strong>Interference from native language usage:</strong> Filipino learners sometimes transfer patterns or vocabulary from Tagalog/Filipino, producing sentences that are grammatically acceptable but stylistically unidiomatic (e.g., “The problem is evident to the group” instead of “The problem is evident among the group”). :contentReference[oaicite:3]{index=3}   </li> </ul>  <h3>   Word Order and Emphasis </h3> <ul>   <li>     <strong>Topic‑prominent language transfer:</strong> Since Philippine languages often follow a topic–comment structure, advanced learners may produce sentences with unusual emphasis or word order in English (e.g., “The report, I have already completed” instead of “I have already completed the report”). :contentReference[oaicite:4]{index=4}   </li>   <li>     <strong>Misplaced modifiers and prepositional phrases:</strong> With increased sentence length, the risk of misplacing modifiers grows (e.g., “Only the manager discussed the plan yesterday afternoon” meaning might shift) — advanced learners sometimes mis‑locate modifiers or prepositional phrases, affecting meaning. :contentReference[oaicite:5]{index=5}   </li> </ul>  <h3>   Cohesion, Discourse Flow and Intra‑sentence Linking </h3> <ul>   <li>     <strong>Over‑reliance on simple linking devices:</strong> Despite being advanced, learners may repeatedly use “and”, “but”, “so” without varying connectors like “therefore”, “however”, “consequently”, which can make sentences feel repetitive. :contentReference[oaicite:6]{index=6}   </li>   <li>     <strong>Difficulty maintaining syntactic and thematic coherence:</strong> In longer sentences and paragraphs, advanced learners may lose track of referents, create ambiguous relations, or misuse relative pronouns, reducing clarity. :contentReference[oaicite:7]{index=7}   </li> </ul>  <h3>   Cognitive Load and Writing Fluency </h3> <ul>   <li>     <strong>Balancing accuracy and complexity:</strong> Advanced learners often attempt sophisticated sentence structures but may sacrifice accuracy for style (e.g., “Having been informed of the results, the students were discussing them in groups” vs. “After the results were announced the students discussed them in groups”). Coherence and accuracy both suffer. :contentReference[oaicite:8]{index=8}   </li>   <li>     <strong>Limited revision and editing skills:</strong> Even when advanced, Filipino learners may submit sentences with errors because revision strategies (e.g., checking clause linkage or modifier placement) are under‑trained. :contentReference[oaicite:9]{index=9}   </li> </ul>  <hr> <h3>   Sources </h3> <p>   <small>     * Article: “Tracking along with sentence structure and grammar when dealing with complex sentences” (World Journal of English Language, Vol. 15, No. 5; 2025) — discusses advanced learners’ struggles with sentence complexity. :contentReference[oaicite:10]{index=10}     <br>   * Qubahan Academic Journal: “Filipinos … learners struggle with forming syntactically correct sentences …” (2024) :contentReference[oaicite:11]{index=11}     <br>   * Study: “Students’ writing compositions … sentence‑structure errors of Filipino ESL writers” (Gustilo & Magno, 2012) :contentReference[oaicite:12]{index=12}   </p>'),
(10, 'advanced', 'grammar', '<h2> Difficulties Faced by Filipino Advanced Learners in English Grammar </h2> <hr> <p>   Filipino learners of English at the advanced level often encounter persistent grammatical difficulties that are less about basic rules and more about the nuanced application of grammar in academic, professional, or high‑stakes contexts. These challenges arise from native‑language interference, mixed exposure to English varieties, insufficient feedback on advanced errors, and the greater complexity of grammar at this level. </p>  <h3>   Subtle L1 Interference and Complex Structures </h3> <ul>   <li>     <strong>Transfer of native word‑order and clause structure:</strong> Advanced learners may still produce sentences influenced by Filipino syntax (e.g., topic‑prominent or verb‑initial patterns) when forming complex English sentences. This leads to unnatural but grammatically plausible constructions.     </li>   <li>     <strong>Difficulty with advanced clause types and subordination:</strong> Errors in relative clauses, nominalizations, passive voice, or clauses embedded within other clauses are common, as learners may revert to simpler structures even at advanced proficiency.     </li> </ul>  <h3>   Tense–Aspect–Modality (TAM) and Agreement Overload </h3> <ul>   <li>     <strong>Inadequate consistency of tense–aspect–modality:</strong> Even advanced learners sometimes shift tense or aspect incorrectly in one sentence, particularly in writing, when expressing sequences or hypothetical conditions.     </li>   <li>     <strong>Agreement across more complex phrases:</strong> Subject–verb agreement remains an issue when the subject is distant from the verb (e.g., with intervening relative clause, inverted sentence) or in more formal register, affecting precision.     </li> </ul>  <h3>   Register, Style, and Grammar Choice </h3> <ul>   <li>     <strong>Register‑appropriate grammar:</strong> Advanced users may struggle to select grammar forms appropriate for formal or academic discourse (e.g., selecting “which” vs. “that”, choosing subjunctive or modal forms, avoiding informal contraction forms).     </li>   <li>     <strong>Consistency in complex writing genres:</strong> Papers, reports, or formal communication demand consistent grammar choices. Advanced learners may mix colloquial forms, tag‑switch, or revert to simpler grammar under cognitive load, reducing clarity and perceived proficiency.     </li> </ul>  <h3>   Feedback, Fossilisation and Self‑Monitoring </h3> <ul>   <li>     <strong>Fossilised errors:</strong> Some grammar errors become entrenched and harder to correct at advanced levels because they are not noticed by learners or teachers assume proficiency is sufficient, leading to persistent subtle mistakes.     </li>   <li>     <strong>Reduced explicit feedback:</strong> As learners enter advanced levels, instruction often shifts to content rather than form, resulting in less focus on grammar accuracy and fewer opportunities to refine advanced grammar forms.     </li> </ul>  <hr> <h3>   Sources </h3> <p>\n  <small>\n    Hinagpisan, M. J., Ora, V., Ybañez, M., Fuentes, A. J. C., Gaputan, B., & Catibag, R. (2019). Common problems and difficulties in learning English as a second language as perceived by Grade 12 ABM students of BCP SY 2018‑2019. <em>Ascendens Asia Singapore – Bestlink College of the Philippines Journal of Multidisciplinary Research</em>, 1(1), 15–28.  \n  </small>\n  <br>\n  <small>\n    Qubahan Academic Journal. (2023). Challenges faced by intermediate and advanced learners in forming grammatically correct sentences. <em>Qubahan Academic Journal</em>, 2(3), 45–58.  \n  </small>\n  <br>\n  <small>\n    Evangelista, J., Mortega, R. J., Sugue, F. M., Pendon, C., Costales, R., & Ablen, D. A. S. (2019). Challenges encountered in learning language proficiency among freshmen English majors at B.C.P. <em>Ascendens Asia Singapore – Bestlink College of the Philippines Journal of Multidisciplinary Research</em>, 1(1), 29–41.  \n  </small>\n</p>'),
(11, 'advanced', 'pronunciation', '<h2> Difficulties Faced by Filipino Advanced Learners in English Pronunciation </h2> <hr> <p>   Even advanced Filipino learners of English often encounter subtle but persistent pronunciation issues that affect intelligibility and suitability for professional or academic communication. These difficulties stem from native‑language phonology, exposure to mixed English varieties, fossilised errors, and higher demands on precision in stress, rhythm, and segmental articulation. </p>  <h3>   Segmental Accuracy and Fossilised Errors </h3> <ul>   <li>     <strong>Phoneme substitutions persist despite proficiency:</strong> Some advanced learners continue to substitute sounds not present in Philippine languages (for example /θ/ → /t/ or /ð/ → /d/), which remains intelligible but marks them as non‑native. :contentReference[oaicite:0]{index=0}   </li>   <li>     <strong>Vowel length and quality mismatches:</strong> Advanced learners may struggle with nuanced vowel contrasts (e.g., /ɪ/ vs /iː/, /ʊ/ vs /uː/) and may simplify diphthongs, leading to subtle distortions of word pronunciation. :contentReference[oaicite:1]{index=1}   </li> </ul>  <h3>   Suprasegmentals: Stress, Rhythm, and Intonation </h3> <ul>   <li>     <strong>Word stress placement matters:</strong> Even advanced speakers may mis‑place primary stress (e.g., stress shifts that change noun/verb forms) or fail to align stress with typical English rhythm, which affects clarity in formal speech.   </li>   <li>     <strong>Sentence‑level rhythm and linking:</strong> Filipino learners often carry a syllable‑timed rhythm into English (equal syllable length) rather than the stress‑timed rhythm of English, making their speech sound non‑native or slightly stilted.   </li>   <li>     <strong>Intonation patterns and pragmatic meaning:</strong> Advanced learners may use intonation incorrectly for emphasis, contrast, or question forms, reducing their pragmatic flexibility in English.     </li> </ul>  <h3>   Exposure, Variety, and Style </h3> <ul>   <li>     <strong>Mixed exposure to English varieties:</strong> Advanced learners often have exposure to both British and American English (and possibly Philippine English). This mixture can lead to inconsistent pronunciation standards (e.g., vowel quality, rhoticity, stress) and uncertainty over which model to follow.   </li>   <li>     <strong>Professional or academic pronunciation demands:</strong> At the advanced level, the expectation shifts from basic intelligibility to professional clarity and nuance (e.g., for presentation, academic discussion). Small pronunciation deviations become more noticeable in such contexts.   </li> </ul>  <h3>   Cognitive Load and Self‑Monitoring </h3> <ul>   <li>     <strong>Maintaining accuracy under pressure:</strong> Advanced learners may slip in pronunciation when speaking spontaneously or under stress (e.g., presentations or interviews), because monitoring pronunciation while producing complex speech increases cognitive load.   </li>   <li>     <strong>Fossilised pronunciation habits:</strong> Some pronunciation errors become habitual and harder to correct at the advanced stage unless explicitly addressed; learners may assume they are “good enough” and stop refining their pronunciation.   </li> </ul>  <hr> <h3>   Sources </h3> <p>   <small>     * Alaga, N. A. C. (2016). ESL learners’ English pronunciation errors: A systematic error rather than accidental. <em>Journal of English Language and Literature</em>, 6(2), 464–469.</small>   <br>   <small>     * Dangin, D., & Wijayanti, N. (2018, August 25). “The study of English phonological errors of advanced second language learners in pronouncing similarly‑spelled words.” <em>Lire Journal: Journal of Linguistics and Literature</em>, 2(1).</small>   <br>   <small>     * Abellana, E. C. Q. (2025). Addressing pronunciation challenges among Filipino senior high school learners: Strategies and pedagogical implications. <em>Journal of Research in Education and Pedagogy</em>, 2(3), 454–463.     </small> </p>');
INSERT INTO `path_info` (`id`, `level`, `level_type`, `info`) VALUES
(12, 'advanced', 'q_and_a', '<h2> Difficulties Faced by Filipinos in Answering Questions in English </h2> <hr> <p>   Although Filipinos are generally proficient in English, many experience challenges when responding to questions, especially in academic or formal settings. These difficulties often stem from linguistic transfer, cultural communication norms, and affective factors such as anxiety or lack of confidence when expressing ideas in a second language. </p>  <h3>   Influence of First Language Structures </h3> <ul>   <li>     <strong>Different Question Formation Rules:</strong> Philippine languages like Tagalog form questions by using particles (e.g., <em>ba</em>) or changing intonation, rather than altering word order. This difference can cause confusion in producing accurate English question responses or inversions (e.g., <em>Why you are late?</em> instead of <em>Why are you late?</em>).   </li>   <li>     <strong>Direct Translations:</strong> Learners often rely on direct translations from their native language, leading to unnatural or grammatically incorrect English answers (e.g., <em>Because I am hungry</em> as a short answer to <em>Why you eat?</em> instead of <em>Because I was hungry</em>).   </li> </ul>  <h3>   Limited Exposure to Authentic Question Types </h3> <ul>   <li>     <strong>Classroom-Focused English Use:</strong> Many Filipino students learn English primarily through textbooks and structured exercises, not spontaneous conversation. As a result, they may struggle to comprehend or respond to more natural or idiomatic English questions.   </li>   <li>     <strong>Difficulty with Indirect and Embedded Questions:</strong> Questions like <em>Could you tell me where the library is?</em> can be confusing because their word order differs from direct questions (<em>Where is the library?</em>).   </li> </ul>  <h3>   Pragmatic and Cultural Factors </h3> <ul>   <li>     <strong>Deference and Politeness Norms:</strong> Filipino culture values respect and avoidance of confrontation. Students may hesitate to give direct answers, especially to authority figures, preferring vague or indirect responses (e.g., <em>Maybe it’s okay</em> instead of <em>I think it’s fine</em>).   </li>   <li>     <strong>Fear of Making Mistakes:</strong> Anxiety about grammatical errors or pronunciation often leads to silence or one-word answers. This affective filter limits their ability to engage in fluid English conversation.   </li> </ul>  <h3>   Cognitive and Processing Challenges </h3> <ul>   <li>     <strong>Translating Before Answering:</strong> Many Filipino learners mentally translate English questions into their native language before forming an answer, which slows response time and increases the chance of grammatical errors.   </li>   <li>     <strong>Complex Question Forms:</strong> Learners may struggle with understanding compound or multi-clause questions, especially in academic settings (e.g., <em>What do you think are the reasons why people migrate?</em>), leading to partial or off-topic answers.   </li> </ul>  <h3>   Listening Comprehension and Accent Variations </h3> <ul>   <li>     <strong>Difficulty Understanding Non-Filipino Accents:</strong> Exposure is often limited to Filipino English or American-accented English. When encountering other varieties (e.g., British, Australian, or Indian English), comprehension of questions may decrease.   </li>   <li>     <strong>Fast Speech and Reduced Forms:</strong> Native speakers’ use of contractions and reductions (e.g., <em>Whatcha doing?</em> for <em>What are you doing?</em>) can confuse learners and affect their ability to answer appropriately.   </li> </ul>  <hr> <h3>   Sources </h3> <p>   <small>     * Bautista, M. L. S. (2004). The grammar of Philippine English. In M. L. S. Bautista & G. O. Bolton (Eds.),      <em>Philippine English: Linguistic and literary perspectives</em> (pp. 228–245). Hong Kong University Press.   </small>   <br>   <small>     * Dayag, D. T. (2007). The discourse of English language education in the Philippines: A reflection of current theories and practices.      <em>Asian Englishes</em>, 10(1), 48–66.   </small>   <br>   <small>     * Bernardo, A. B. I. (2008). English in Philippine education: Issues and concerns.      <em>Asian Englishes</em>, 11(1), 36–48.   </small>   <br>   <small>     * Tupas, R. (2015). Inequalities of multilingualism: Challenges to mother tongue-based multilingual education.      <em>Language and Education</em>, 29(2), 112–124.   </small> </p>');

-- --------------------------------------------------------

--
-- Table structure for table `pronunciation`
--

CREATE TABLE `pronunciation` (
  `id` int(9) NOT NULL,
  `level` varchar(12) NOT NULL,
  `audio_link` varchar(200) NOT NULL,
  `phonemes` varchar(50) NOT NULL,
  `info` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pronunciation`
--

INSERT INTO `pronunciation` (`id`, `level`, `audio_link`, `phonemes`, `info`) VALUES
(1, 'advanced', '../AUDIOS/Pronunciation/Intermediate/word_intermediate_1.wav', 'əpɹowpɹiətʰ', 'appropriate'),
(3, 'advanced', '../AUDIOS/Pronunciation/Intermediate/polite_reply_1.wav', 'ajnlaɪksamntwiz', 'I\'d like some, please'),
(4, 'advanced', '../AUDIOS/Pronunciation/Intermediate/word_intermediate_2.wav', 'fowkiːs', 'focus'),
(5, 'advanced', '../AUDIOS/Pronunciation/Intermediate/word_intermediate_3.wav', 'ʃɑɹkləd', 'chocolate'),
(6, 'advanced', '../AUDIOS/Pronunciation/Intermediate/word_intermediate_4.wav', 'mɛʒuː', 'measure'),
(7, 'testing', '../AUDIOS/Pronunciation/Level_exam/word_level_exam_1.wav', 'hajɹɑɹkiː', 'hierarchy'),
(8, 'level_exam', '../AUDIOS/Pronunciation/Level_exam/word_level_exam_2.wav', 'ɒpʌkəmuːo', 'applicable'),
(9, 'level_exam', '../AUDIOS/Pronunciation/Level_exam/word_level_exam_3.wav', 'ɪndəɡʊnt', 'indigent'),
(10, 'level_exam', '../AUDIOS/Pronunciation/Level_exam/pronunciation_en_acquire.mp3', 'əpwajɹ', 'aquire');

-- --------------------------------------------------------

--
-- Table structure for table `q_and_a`
--

CREATE TABLE `q_and_a` (
  `id` int(9) NOT NULL,
  `level` varchar(12) NOT NULL,
  `story` varchar(1500) NOT NULL,
  `question` varchar(100) NOT NULL,
  `answers` varchar(1200) NOT NULL,
  `info` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `q_and_a`
--

INSERT INTO `q_and_a` (`id`, `level`, `story`, `question`, `answers`, `info`) VALUES
(1, 'advanced', 'The 6:00 AM alarm startled Sarah. Dressed in a navy suit for her junior analyst job in Canary Wharf, London, she skipped breakfast. Grabbing coffee, she ran to the Jubilee Line. The tube was delayed for 15 minutes near Westminster due to a signal failure, stressing her about her 9:00 AM meeting. She reviewed a 20-page report during the wait. Arriving at One Canada Square at 8:45 AM, she realized she had forgotten her access badge, causing a further delay waiting for security.', 'What is Sarah\'s job?', 'Sarah works as a junior analyst.:Great!;Analyst.:What kind of analyst?;She is a junior analyst.:Don\'t just say \"she\";Sarah is a junior analyst.:Great!;She works as a junior analyst.:Don\'t just say \"she\";Junior analyst.:Try writing longer', ''),
(2, 'advanced', 'The 6:00 AM alarm startled Sarah. Dressed in a navy suit for her junior analyst job in Canary Wharf, London, she skipped breakfast. Grabbing coffee, she ran to the Jubilee Line. The tube was delayed for 15 minutes near Westminster due to a signal failure, stressing her about her 9:00 AM meeting. She reviewed a 20-page report during the wait. Arriving at One Canada Square at 8:45 AM, she realized she had forgotten her access badge, causing a further delay waiting for security.', 'In which city does Sarah live and work?', 'Sarah lives and works in London.:Great!;London.:Use the word \"in\";In London.:Try to write longer;She lives and works in London.:Don\'t just say \"she\";The city Sarah lives and works in is London.:Awkward phrasing;London is where Sarah lives and works.:Great, but it\'s strange to write in a passive voice;London is where she lives and works.:Try to use an active voice + who is \"she\"?', ''),
(3, 'advanced', '../AUDIOS/Q_and_a/q_and_a_advanced_1.wav', 'What is his job?', 'He works as a delivery driver for a small bakery.:Great!;He works as a delivery driver.:Great!;A delivery driver.:Good, but try writing a little longer;Delivery driver.:Try writing a longer answer;He is a delivery driver.:Excellent!;His job is a delivery driver.:That\'s a good answer.;Delivery man.:Good, but be more formal;A driver for a bakery.:Good, but try to use a full sentence;He drives for a small bakery.:Excellent detail!', ''),
(4, 'advanced', '../AUDIOS/Q_and_a/q_and_a_advanced_1.wav', 'What is the name of his first stop?', 'His first stop is the Daily Grind Cafe:Great!;The first stop is the Daily Grind Cafe.:Great!;The Daily Grind Cafe.:Correct!;Daily Grind Cafe.:Good, but try to include \"the\" before the name;It is the Daily Grind Cafe.:Great, but what is \"it\"?;His first stop is Daily Grind Cafe.:Correct, but the formal name includes \"the\";Daily Grind Cafe is his first stop.:Good, though the sentence structure is a bit inverted;The cafe called the Daily Grind Cafe.:A bit wordy, but correct;The first stop is a cafe.:Say the name of the cafe;The cafe Daily Grind Cafe.:Good, but slightly redundant', ''),
(5, 'remove', '../AUDIOS/Q_and_a/q_and_a_advanced_1.wav', 'What time does the speaker start his day?', 'He starts his day at 6:30 A.M.:Great!;He starts his day at 6:30 A.M.:Great!;6:30 A.M.:Good, but try to restate the question at the start;They start their day at 6:30AM.:Great!;He starts his day at 6:30AM.:Great!;He starts his day at 6:30AM.:Great!;6:30AM.:Good, but try to restate the question at the start;They start their day at 6:30 A.M.:Great!;He starts his day at 6:30A.M.:Great!;He starts his day at 6:30A.M.:Great!;6:30A.M.:Good, but try to restate the question at the start', ''),
(6, 'advanced', '../AUDIOS/Q_and_a/q_and_a_advanced_1.wav', 'He mentions that his usual route takes him down what street?', 'His usual route takes him down Oak Street.:Great!;Oak Street.:Good, but try restating the question;It takes him down Oak Street.:Say exactly \"what\" takes him down Oak Street;His usual route takes him down Oak St.:Great!;Oak St.:Good, but try restating the question;It takes him down Oak St.:Say exactly \"what\" takes him down Oak Street;He drives down Oak Street.:Excellent!;The street is Oak Street.:Correct!;The street he takes is Oak Street.:Very precise. Well done;He drives down Oak St.:Excellent!;The street is Oak St.:Correct!;Oak Street is the street.:Good, though a bit indirect and redundant', ''),
(7, 'level_exam', '../AUDIOS/Q_and_a/Level_exam/q_and_a_level_exam_1.wav', 'Which intersection did the main office that received the rush report stand on?', 'The main office that received the rush report stood at the intersection of Elmwood Avenue and Central Street.:Excellent!;The main office that received the rush report stood at the intersection of Elmwood Ave. and Central St.:Excellent!;The main office stood at the intersection of Elmwood Avenue and Central Street.:Great!;The main office was at the intersection of Elmwood Ave. and Central St.:Great!;The main office was at the intersection of Elmwood Avenue and Central Street.:Great!;The main office stood at the intersection of Elmwood Ave. and Central St.:Great!;Elmwood Avenue and Central Street.:Good, but say \"what\" stood there;Elmwood Ave. and Central St.:Good, but say \"what\" stood there;It was on the intersection of Elmwood Avenue and Central Street:Say exactly what \"it\" is;It stood on the intersection of Elmwood Ave. and Central St.:Say exactly what \"it\" is;It stood on the intersection of Elmwood Avenue and Central Street:Say exactly what \"it\" is;It was on the intersection of Elmwood Ave. and Central St.:Say exactly what \"it\" is;Elmwood Avenue and Central Street:Try making your answer more detailed;Say exactly what \"it\" is;Elmwood Ave. and Central St.:Give more details', ''),
(8, 'level_exam', '../AUDIOS/Q_and_a/Level_exam/q_and_a_level_exam_1.wav', 'What floor did she specifically have to go to?', 'She specifically had to go to the fifth-floor.:Great!;She specifically had to go to the fifth-floor meeting room.:Great attention to detail!;She had to go to the fifth-floor.:Great!;She had to go to the fifth-floor meeting room.:Great attention to detail!;The fifth-floor.:Okay, but try to say \"who\" exactly went there;She went to the fifth-floor.:Good;The fifth-floor.:Okay, but try to make your answer more detailed;Fifth floor.:Remember the dash between \"fifth\" and \"floor\";5th floor.:Use the whole word: \"fifth\"', ''),
(9, 'level_exam', 'Elena Reyes, a methodical forensic accountant, began her intensive search for illicit transfers at 7:30 a.m. sharp in her downtown office. By 10:00 a.m., she was meeting with Detective Miller at the County Records building, situated on the 700 block of Oak Street, where they spent hours poring over old ledgers. The crucial discovery—a complex series of shell company payments—was pinpointed around 1:15 p.m., a breakthrough that validated weeks of work. Recognizing the urgency, Elena immediately drafted a summary of the evidence, managing to submit the complete preliminary findings package to the prosecutor\'s office by 3:55 p.m., bringing the high-stakes case one step closer to resolution.', 'What was the name of the detective Elena met with at the County Records building?', 'The name of the detective Elena met with at the County Records Building was Detective Miller.:Perfect!;The name of the detective Elena met with was Detective Miller.:Excellent!;The detective\'s name was Detective Miller.:Great!;Elena met with a detective named Detective Miller.:Alright!;Elena met with a detective at the County Records Building named Detective Miller.:Great job!;She met with Detective Miller.:Okay;She met with Detective Miller at the County Records Building:Good;Detective Miller.:Good', ''),
(10, 'advanced', 'At 7:30 AM, Daniel locked his apartment on Baker Street in London and rode his blue bicycle to the nearby Regent\'s Park. He planned to meet his friend Emma at the park\'s south entrance at 8:00 AM for a morning jog. On the way, he stopped at a coffee cart on Marylebone Road to buy a cappuccino. When he arrived, Emma was already stretching near the fountain, and they started running along the paved trail around the lake.', 'Where did Daniel meet Emma?', 'Regent\'s Park.:Be specific and include the park\'s name;The south entrance of Regent\'s Park.:Even better, include the exact entrance;At the fountain in Regent\'s Park.:Good detail, mention landmark;In a park.:Too vague, mention the park\'s name', ''),
(11, 'advanced', 'On a bright Saturday morning, Maria decided to visit the new bakery on Willow Street. She parked her red bicycle next to Greenwood Park, which was only two blocks away. The bakery, called “Sunrise Delights”, had a bright yellow awning and a small chalkboard sign advertising fresh blueberry muffins.\r\n\r\nInside, Maria greeted the owner, Mr. Patel, who was arranging pastries on the counter. She bought two blueberry muffins and a cup of cappuccino. While sitting at a small wooden table near the window, she noticed a flyer for a local art exhibition at Maple Community Center, happening next weekend. Excited by the idea, she decided to check it out with her friend Liam, who lived on Oak Avenue, just a ten-minute walk from the bakery.\r\n\r\nAfter finishing her coffee, Maria rode her bicycle back along Willow Street, taking in the autumn colors of the trees lining the sidewalk.', 'What street is the bakery located on?', 'Willow Street.:Good, but try making the answer longer;The bakery is located on Willow Street.:Great!;Willow St.:Good, but try making the answer longer;The bakery is located on Willow St.:Great!', ''),
(12, 'advanced', 'On a bright Saturday morning, Maria decided to visit the new bakery on Willow Street. She parked her red bicycle next to Greenwood Park, which was only two blocks away. The bakery, called “Sunrise Delights”, had a bright yellow awning and a small chalkboard sign advertising fresh blueberry muffins.\r\n\r\nInside, Maria greeted the owner, Mr. Patel, who was arranging pastries on the counter. She bought two blueberry muffins and a cup of cappuccino. While sitting at a small wooden table near the window, she noticed a flyer for a local art exhibition at Maple Community Center, happening next weekend. Excited by the idea, she decided to check it out with her friend Liam, who lived on Oak Avenue, just a ten-minute walk from the bakery.\r\n\r\nAfter finishing her coffee, Maria rode her bicycle back along Willow Street, taking in the autumn colors of the trees lining the sidewalk.', 'What kind of muffin did Maria buy?', 'Blueberry muffin.:Good, but use the article \"a\" at the start;A blueberry muffin.:Good, but try making the answer longer;She bought a blueberry muffin.:Great, but who is \"she\"?;Maria bought a blueberry muffin.:Excellent!;The kind of muffin that Maria bought is blueberry.:Good, but very verbose.', ''),
(13, 'advanced', 'On a bright Saturday morning, Maria decided to visit the new bakery on Willow Street. She parked her red bicycle next to Greenwood Park, which was only two blocks away. The bakery, called “Sunrise Delights”, had a bright yellow awning and a small chalkboard sign advertising fresh blueberry muffins.\r\n\r\nInside, Maria greeted the owner, Mr. Patel, who was arranging pastries on the counter. She bought two blueberry muffins and a cup of cappuccino. While sitting at a small wooden table near the window, she noticed a flyer for a local art exhibition at Maple Community Center, happening next weekend. Excited by the idea, she decided to check it out with her friend Liam, who lived on Oak Avenue, just a ten-minute walk from the bakery.\r\n\r\nAfter finishing her coffee, Maria rode her bicycle back along Willow Street, taking in the autumn colors of the trees lining the sidewalk.', 'Who is the owner of the bakery?', 'Mr. Patel.:Good, but try making your answer longer;The owner of the bakery is Mr. Patel.:Great!;Mister Patel.:Good, but try making your answer longer;The owner of the bakery is Mister Patel.:Great!;Mr. Patel is the owner.:The owner of what?;Mister Patel is the owner.:The owner of what?;Mr. Patel is the owner of the bakery.:Good!;Mister Patel is the owner of the bakery.:Good!', ''),
(14, 'advanced', 'On a bright Saturday morning, Maria decided to visit the new bakery on Willow Street. She parked her red bicycle next to Greenwood Park, which was only two blocks away. The bakery, called “Sunrise Delights”, had a bright yellow awning and a small chalkboard sign advertising fresh blueberry muffins.\r\n\r\nInside, Maria greeted the owner, Mr. Patel, who was arranging pastries on the counter. She bought two blueberry muffins and a cup of cappuccino. While sitting at a small wooden table near the window, she noticed a flyer for a local art exhibition at Maple Community Center, happening next weekend. Excited by the idea, she decided to check it out with her friend Liam, who lived on Oak Avenue, just a ten-minute walk from the bakery.\r\n\r\nAfter finishing her coffee, Maria rode her bicycle back along Willow Street, taking in the autumn colors of the trees lining the sidewalk.', 'What is the name of the community center mentioned in the story?', 'Maple Community Center.:Good, but try making your answer longer;The name of the community center is the Maple Community Center.:Good!;The community center\'s name is the Maple Community Center:Great!;Its name is the Maple Community Center:What exactly is named that?', ''),
(15, 'advanced', 'On a bright Saturday morning, Maria decided to visit the new bakery on Willow Street. She parked her red bicycle next to Greenwood Park, which was only two blocks away. The bakery, called “Sunrise Delights”, had a bright yellow awning and a small chalkboard sign advertising fresh blueberry muffins.\r\n\r\nInside, Maria greeted the owner, Mr. Patel, who was arranging pastries on the counter. She bought two blueberry muffins and a cup of cappuccino. While sitting at a small wooden table near the window, she noticed a flyer for a local art exhibition at Maple Community Center, happening next weekend. Excited by the idea, she decided to check it out with her friend Liam, who lived on Oak Avenue, just a ten-minute walk from the bakery.\r\n\r\nAfter finishing her coffee, Maria rode her bicycle back along Willow Street, taking in the autumn colors of the trees lining the sidewalk.', 'What color is Maria’s bicycle?', 'Red.:Good, but try making your answer longer;It is red.:What is red?;Her bicycle\'s color is red.:Don\'t just say her;Her bicycle is red.:Don\'t just say her;Maria\'s bicycle is red.:Great!', ''),
(16, 'advanced', 'On a chilly Tuesday morning, Tom decided to take a walk around Riverbend Lake. He wore his green jacket and carried a small black backpack. As he walked along Lakeside Avenue, he noticed a new café named “The Cozy Corner”. The café had a bright red door and served pumpkin spice lattes.\r\n\r\nTom decided to stop for a drink and met the barista, Sophie, who recommended the café’s homemade chocolate croissants. While sitting at a table near the lake view window, Tom read a notice about a jazz concert happening next Friday at Harmony Hall, located on Elm Street. Excited, he sent a message to his friend Nina, inviting her to join.\r\n\r\nAfter finishing his latte and croissant, Tom continued his walk around Riverbend Lake, enjoying the ducks swimming near the pier.', 'What is the name of the lake Tom walked around?', 'Riverbend Lake.:Good, but try extending your answer;The lake\'s name is Riverbend Lake.:Good!;Tom walked around Riverbend Lake.:Great!;He walked around Riverbend Lake.:Who walked around Riverbend Lake?;The name of the lake is Riverbend Lake.:Great!', ''),
(17, 'advanced', 'On a chilly Tuesday morning, Tom decided to take a walk around Riverbend Lake. He wore his green jacket and carried a small black backpack. As he walked along Lakeside Avenue, he noticed a new café named “The Cozy Corner”. The café had a bright red door and served pumpkin spice lattes.\r\n\r\nTom decided to stop for a drink and met the barista, Sophie, who recommended the café’s homemade chocolate croissants. While sitting at a table near the lake view window, Tom read a notice about a jazz concert happening next Friday at Harmony Hall, located on Elm Street. Excited, he sent a message to his friend Nina, inviting her to join.\r\n\r\nAfter finishing his latte and croissant, Tom continued his walk around Riverbend Lake, enjoying the ducks swimming near the pier.', 'What color is Tom’s jacket?', 'Green.:Good, but try extending your answer;It is green.:What is green?;His jacket is green.:Whose jacket is green?;Tom\'s jacket is green.:Good!;The color of Tom\'s jacket is green.:Great!', ''),
(18, 'advanced', 'On a chilly Tuesday morning, Tom decided to take a walk around Riverbend Lake. He wore his green jacket and carried a small black backpack. As he walked along Lakeside Avenue, he noticed a new café named “The Cozy Corner”. The café had a bright red door and served pumpkin spice lattes.\r\n\r\nTom decided to stop for a drink and met the barista, Sophie, who recommended the café’s homemade chocolate croissants. While sitting at a table near the lake view window, Tom read a notice about a jazz concert happening next Friday at Harmony Hall, located on Elm Street. Excited, he sent a message to his friend Nina, inviting her to join.\r\n\r\nAfter finishing his latte and croissant, Tom continued his walk around Riverbend Lake, enjoying the ducks swimming near the pier.', 'Who is the barista at the café?', 'Sophie.;Good, but try extending your answer;Her name is Sophie.;What is she?;The barista\'s name is Sophie.;Great!;The barista at the cafe\'s name is Sophie.;Excellent attention to detail!;Sophie is the name of the barista at the cafe.:Excellent attention to detail!', ''),
(19, 'advanced', 'On a chilly Tuesday morning, Tom decided to take a walk around Riverbend Lake. He wore his green jacket and carried a small black backpack. As he walked along Lakeside Avenue, he noticed a new café named “The Cozy Corner”. The café had a bright red door and served pumpkin spice lattes.\r\n\r\nTom decided to stop for a drink and met the barista, Sophie, who recommended the café’s homemade chocolate croissants. While sitting at a table near the lake view window, Tom read a notice about a jazz concert happening next Friday at Harmony Hall, located on Elm Street. Excited, he sent a message to his friend Nina, inviting her to join.\r\n\r\nAfter finishing his latte and croissant, Tom continued his walk around Riverbend Lake, enjoying the ducks swimming near the pier.', 'On which street is Harmony Hall located?', 'Elm Street.:Good, but try extending your answer;It is located on Elm Street.:What is located on Elm Street?;Harmony Hall is located on Elm Street.:Great!;Elm Street is where harmony hall is located.:Good, but slightly backward sentence construction;Elm St.:Good, but try extending your answer;It is located on Elm St.:What is located on Elm St?;Harmony Hall is located on Elm St.:Great!;Elm Street is where harmony hall is located.:Good, but slightly backward sentence construction', ''),
(20, 'advanced', 'On a chilly Tuesday morning, Tom decided to take a walk around Riverbend Lake. He wore his green jacket and carried a small black backpack. As he walked along Lakeside Avenue, he noticed a new café named “The Cozy Corner”. The café had a bright red door and served pumpkin spice lattes.\r\n\r\nTom decided to stop for a drink and met the barista, Sophie, who recommended the café’s homemade chocolate croissants. While sitting at a table near the lake view window, Tom read a notice about a jazz concert happening next Friday at Harmony Hall, located on Elm Street. Excited, he sent a message to his friend Nina, inviting her to join.\r\n\r\nAfter finishing his latte and croissant, Tom continued his walk around Riverbend Lake, enjoying the ducks swimming near the pier.', 'What kind of pastry did Sophie recommend?', 'Chocolate croissants.:Good, but try making your answer longer;She recommended chocolate croissants.:Who recommended chocolate croissants?;Sophie recommended chocolate croissants.:Great!;The kind of pastry she recommended was chocolate croissants.:Excellent, but who is she?;The kind of pastry Sophie recommended was chocolate croissants.:Excellent!', '');

-- --------------------------------------------------------

--
-- Table structure for table `sentence_form`
--

CREATE TABLE `sentence_form` (
  `id` int(9) NOT NULL,
  `level` varchar(18) NOT NULL,
  `parts` varchar(100) NOT NULL,
  `answers` varchar(230) NOT NULL,
  `info` varchar(3000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sentence_form`
--

INSERT INTO `sentence_form` (`id`, `level`, `parts`, `answers`, `info`) VALUES
(1, 'beginner', 'going down;The car;the road;is blue;quickly', 'The car going down the road quickly is blue;The car quickly going down the road is blue', '<p>\n  Both sentences, \n  <strong>\"The car going down the road quickly is blue\"</strong> \n  and \n  <strong>\"The car quickly going down the road is blue\"</strong>, \n  are grammatically correct because they follow the standard English \n  <strong>Subject-Predicate</strong> \n  structure, where the subject is expanded by a descriptive phrase.\n</p>\n\n<ul>\n  <li>\n    <strong>The car</strong>: This is the simple \n    <strong>Subject</strong>.\n  </li>\n  <li>\n    <strong>going down the road quickly</strong> / \n    <strong>quickly going down the road</strong>: This is a reduced relative clause (a participle phrase) that modifies the subject \"The car.\" It acts as a descriptive adjective phrase.\n    <ul>\n      <li>\n        <strong>going down</strong>: The present participle, part of the verb phrase.\n      </li>\n      <li>\n        <strong>the road</strong>: The object of the prepositional phrase \"down the road.\"\n      </li>\n      <li>\n        <strong>quickly</strong>: An \n        <strong>adverb</strong> modifying the participle \"going.\" In English, adverbs modifying participles or verbs can often be placed either before or after the phrase they modify (though placing it after the verb/participle, as in the first sentence, is often clearer or more natural).\n      </li>\n    </ul>\n  </li>\n  <li>\n    <strong>is blue</strong>: This is the main \n    <strong>Predicate</strong>. \"is\" is the main verb, and \"blue\" is the subject complement.\n  </li>\n</ul>\n\n<p>\n  The full subject in both cases is \n  <strong>\"The car [descriptive phrase]</strong>.\" The sentence states the main idea: \n  <strong>\"The car is blue,\"</strong> \n  and the participle phrase merely specifies *which* car is blue. The parts \n  <strong>\"The car\" &rarr; \"going down the road\" &rarr; \"quickly\" &rarr; \"is blue\"</strong> \n  (or with \"quickly\" placed earlier) create a logical and well-formed sentence describing the color of a specific, moving vehicle.\n</p>'),
(2, 'beginner', 'The restaurant;is;that corner;just past', 'The restaurant is just past that corner', '<p>\n  The sentence \n  <strong>\"The restaurant is just past that corner\"</strong> \n  is correct because the parts form a grammatically complete and meaningful statement following standard English sentence structure: \n  <strong>Subject-Verb-Complement</strong> (or Subject-Verb-Adverbial Phrase).\n</p>\n\n<ul>\n  <li>\n    <strong>The restaurant</strong> acts as the \n    <strong>subject</strong> (the thing being described).\n  </li>\n  <li>\n    <strong>is</strong> is the \n    <strong>verb</strong> (specifically, a form of <em>to be</em>, linking the subject to its location).\n  </li>\n  <li>\n    <strong>just past that corner</strong> is an \n    <strong>adverbial phrase</strong> modifying the verb and describing the \n    <strong>location</strong> of the restaurant. \"Just past\" acts as a compound preposition or adverbial modifier indicating position immediately after \"that corner,\" which is the object of the prepositional phrase.\n  </li>\n</ul>'),
(3, 'beginner', 'museum;the;visit;tomorrow;will;They', 'They will visit the museum tomorrow', '<p>\n  The sentence \n  <strong>\"They will visit the museum tomorrow\"</strong> \n  is grammatically correct because it follows the standard English \n  <strong>Subject &rarr; Verb &rarr; Object &rarr; Adverbial</strong> \n  structure, forming a coherent statement about a future action.\n</p>\n\n<ul>\n  <li>\n    <strong>They</strong>: The \n    <strong>Subject</strong> (the doer of the action).\n  </li>\n  <li>\n    <strong>will visit</strong>: The \n    <strong>Verb Phrase</strong>, using the auxiliary verb \"will\" to indicate the \n    <strong>future tense</strong> of the main verb \"visit.\"\n  </li>\n  <li>\n    <strong>the museum</strong>: The \n    <strong>Object</strong> (or Direct Object), the thing receiving the action of \"visit.\" \"The\" is the definite article specifying the place.\n  </li>\n  <li>\n    <strong>tomorrow</strong>: The \n    <strong>Adverbial of Time</strong>, specifying when the action will occur.\n  </li>\n</ul>\n\n<p>\n  The parts are arranged logically to convey the full thought: \n  <strong>They</strong> (who) \n  <strong>will visit</strong> (what action in the future) \n  <strong>the museum</strong> (where/what) \n  <strong>tomorrow</strong> (when).\n</p>'),
(4, 'beginner', 'coffee;morning;quickly;her;drank;She', 'She quickly drank her morning coffee', '<p>\n  The sentence \n  <strong>\"She quickly drank her morning coffee\"</strong> \n  is grammatically correct because it adheres to the basic \n  <strong>Subject-Verb-Object</strong> \n  structure, with appropriate modifiers added to specify the action.\n</p>\n\n<ul>\n  <li>\n    <strong>She</strong>: This is the \n    <strong>Subject</strong> (a pronoun performing the action).\n  </li>\n  <li>\n    <strong>drank</strong>: This is the main \n    <strong>Verb</strong> (the action).\n  </li>\n  <li>\n    <strong>quickly</strong>: This is an \n    <strong>Adverb</strong> modifying the verb \"drank,\" specifying \n    <em>how</em> \n    she performed the action. In English, adverbs of manner often go after the verb.\n  </li>\n  <li>\n    <strong>her morning coffee</strong>: This is the \n    <strong>Direct Object</strong> (what was drunk).\n    <ul>\n      <li>\n        <strong>coffee</strong>: The head noun of the object phrase.\n      </li>\n      <li>\n        <strong>her</strong>: A \n        <strong>Possessive Determiner</strong> specifying whose coffee it is.\n      </li>\n      <li>\n        <strong>morning</strong>: An \n        <strong>Adjective</strong> modifying \"coffee,\" specifying \n        <em>which</em> \n        coffee it is (the one consumed in the morning).\n      </li>\n    </ul>\n  </li>\n</ul>\n\n<p>\n  The arrangement \n  <strong>\"She &rarr; quickly &rarr; drank &rarr; her morning coffee\"</strong> \n  creates a complete, concise, and logical statement describing a subject\'s fast consumption of a specific beverage.\n</p>'),
(5, 'beginner', 'is;cat;The;the mat;on', 'The cat is on the mat', '<p>\n  The sentence \n  <strong>\"The cat is on the mat\"</strong> \n  is correct because the parts assemble into a complete, logical statement that follows the standard English \n  <strong>Subject-Verb-Complement</strong> \n  pattern.\n</p>\n\n<ul>\n  <li>\n    <strong>The cat</strong>: This functions as the \n    <strong>Subject</strong> (the thing whose location is being stated). \"The\" is the article defining the noun \"cat.\"\n  </li>\n  <li>\n    <strong>is</strong>: This is the main \n    <strong>Verb</strong> (a form of *to be*), which acts as a linking verb connecting the subject to its location.\n  </li>\n  <li>\n    <strong>on the mat</strong>: This is a \n    <strong>Prepositional Phrase</strong> that functions as the complement, describing the \n    <strong>location</strong> of the cat.\n    <ul>\n      <li>\n        <strong>on</strong>: The \n        <strong>preposition</strong>, showing the relationship between the cat and the mat.\n      </li>\n      <li>\n        <strong>the mat</strong>: The object of the preposition.\n      </li>\n    </ul>\n  </li>\n</ul>\n\n<p>\n  The construction \n  <strong>\"The cat\" &rarr; \"is\" &rarr; \"on\" &rarr; \"the mat\"</strong> \n  is the only arrangement of these parts that forms a coherent, declarative sentence describing the cat\'s position.\n</p>'),
(6, 'beginner', 'fruits;over;there;for;the;How much;?', 'How much for the fruits over there?', '<p>\n  The sentence \n  <strong>\"How much for the fruits over there?\"</strong> \n  is grammatically correct and functions as a standard question asking about the price of specific items. It follows the structure of an interrogative sentence (a question) that starts with a question word or phrase.\n</p>\n\n<ul>\n  <li>\n    <strong>How much</strong>: This is the \n    <strong>interrogative phrase</strong> (question phrase) used to ask about the price or cost.\n  </li>\n  <li>\n    <strong>for</strong>: This is a \n    <strong>preposition</strong> indicating the reason or purpose of the cost being inquired about.\n  </li>\n  <li>\n    <strong>the fruits</strong>: This is the object of the preposition \"for,\" specifying the items whose price is being questioned. \n    <strong>\"the\"</strong> (determiner) modifies \n    <strong>\"fruits\"</strong> (noun).\n  </li>\n  <li>\n    <strong>over there</strong>: This is an \n    <strong>adverbial phrase</strong> of place, clarifying the location of the \"fruits.\" \n    <strong>\"over\"</strong> (preposition/adverb) and \n    <strong>\"there\"</strong> (adverb) work together to point out the specific location.\n  </li>\n  <li>\n    <strong>?</strong>: The \n    <strong>punctuation</strong> marks it as a question.\n  </li>\n</ul>\n\n<p>\n  The core of the question is \n  <strong>\"How much for the fruits?\"</strong>, \n  and the phrase \n  <strong>\"over there\"</strong> \n  is added to point out the specific fruits being referenced, making the sentence complete and clear in its intent.\n</p>'),
(7, 'beginner', 'year;time;this;is;really;The;park;at;of;pretty', 'The park is really pretty at this time of year;The park at this time of year is really pretty', '<p>\n  Both sentences, \n  <strong>\"The park is really pretty at this time of year\"</strong> \n  and \n  <strong>\"The park at this time of year is really pretty\"</strong>, \n  are correct. They contain the same essential parts arranged in two grammatically valid ways that emphasize different parts of the sentence.\n</p>\n\n<ul>\n  <li>\n    <strong>The park</strong>: The main \n    <strong>Subject</strong> (what the sentence is about).\n  </li>\n  <li>\n    <strong>is</strong>: The main \n    <strong>Verb</strong> (linking verb).\n  </li>\n  <li>\n    <strong>really pretty</strong>: The \n    <strong>Complement</strong>/Predicate Adjective (describes the subject, intensified by the adverb \"really\").\n  </li>\n  <li>\n    <strong>at this time of year</strong>: An \n    <strong>Adverbial Phrase of Time</strong> (specifies *when* the park is pretty, using the parts \"at,\" \"this,\" \"time,\" \"of,\" and \"year\").\n  </li>\n</ul>\n\n<p>\n  The difference lies in the placement of the adverbial phrase \n  <strong>\"at this time of year\"</strong>:\n</p>\n\n<h3>&#x1F449; Sentence 1: \"The park is really pretty at this time of year\"</h3>\n<p>\n  This follows the most common English order: \n  <strong>Subject &rarr; Verb &rarr; Complement &rarr; Adverbial Phrase</strong>. This is typically the most natural and least formal way to structure this type of statement.\n</p>\n\n<h3>&#x1F449; Sentence 2: \"The park at this time of year is really pretty\"</h3>\n<p>\n  In this structure, the adverbial phrase \n  <strong>\"at this time of year\"</strong> \n  is placed immediately after the subject (\"The park\"), acting as a type of non-essential modifier or qualifier that separates the subject from the verb. The structure becomes: \n  <strong>Subject &rarr; Adverbial Phrase &rarr; Verb &rarr; Complement</strong>. This placement is correct and often used to add subtle emphasis or a slightly more formal tone.\n</p>'),
(8, 'beginner', 'This house;some;need;in;is;of;repairs', 'This house is in need of some repairs', '<p>\n  The sentence \n  <strong>\"This house is in need of some repairs\"</strong> \n  is grammatically correct because it uses the parts to form a coherent statement based on the fixed idiom \n  <strong>\"in need of\"</strong>, \n  following the standard \n  <strong>Subject-Verb-Complement</strong> \n  structure.\n</p>\n\n<ul>\n  <li>\n    <strong>This house</strong>: The \n    <strong>Subject</strong> (the item being discussed).\n  </li>\n  <li>\n    <strong>is</strong>: The main \n    <strong>Verb</strong> (linking verb, a form of *to be*).\n  </li>\n  <li>\n    <strong>in need of some repairs</strong>: The \n    <strong>Complement</strong> (a prepositional phrase acting as an adjective or noun phrase describing the state of the house).\n    <ul>\n      <li>\n        <strong>in need of</strong>: This is a common \n        <strong>idiomatic phrase</strong> meaning requiring or lacking something.\n      </li>\n      <li>\n        <strong>some repairs</strong>: This is the object of the prepositional phrase, specifying *what* the house is in need of. \"Some\" modifies the plural noun \"repairs.\"\n      </li>\n    </ul>\n  </li>\n</ul>\n\n<p>\n  The arrangement \n  <strong>\"This house &rarr; is &rarr; in &rarr; need &rarr; of &rarr; some &rarr; repairs\"</strong> \n  correctly places the subject, the linking verb, and the fixed prepositional phrase to express the condition of the house.\n</p>'),
(9, 'level_exam', 'The conference;after;been;the storm;the coast;postponed;unexpectedly;hit;had', 'The conference had been postponed after the storm unexpectedly hit the coast;The conference had been postponed unexpectedly after the storm hit the coast;The conference had been postponed after the storm hit the coast unexpectedly', '<p>\n  All three sentences—\n  <strong>\"The conference had been postponed after the storm unexpectedly hit the coast,\"</strong> \n  <strong>\"The conference had been postponed unexpectedly after the storm hit the coast,\"</strong> \n  and \n  <strong>\"The conference had been postponed after the storm hit the coast unexpectedly\"</strong>—\n  are grammatically correct examples of the \n  <strong>Past Perfect Passive Voice</strong> \n  combined with an adverb and a subordinate clause. They are constructed correctly from the given parts.\n</p>\n\n<ul>\n  <li>\n    <strong>The conference</strong>: The main \n    <strong>Subject</strong> (the receiver of the action).\n  </li>\n  <li>\n    <strong>had been postponed</strong>: The \n    <strong>Past Perfect Passive Verb Phrase</strong>, formed by \n    **had** + **been** + **postponed**, indicating a completed action in the past before another past action.\n  </li>\n  <li>\n    <strong>after the storm hit the coast</strong>: This is an \n    <strong>Adverbial Clause of Time</strong> \n    (subordinate clause) that provides the context for the postponement.\n    <ul>\n      <li>\n        <strong>the storm</strong>: Subject of the clause.\n      </li>\n      <li>\n        <strong>hit</strong>: Verb of the clause.\n      </li>\n      <li>\n        <strong>the coast</strong>: Object of the clause.\n      </li>\n    </ul>\n  </li>\n  <li>\n    <strong>unexpectedly</strong>: The \n    <strong>Adverb</strong>. Its correct placement depends on what it is intended to modify:\n    <ul>\n      <li>\n        <strong>Sentence 1 (unexpectedly hit)</strong>: It modifies the verb \n        <em>hit</em>, meaning the storm\'s arrival was unexpected.\n      </li>\n      <li>\n        <strong>Sentence 2 (postponed unexpectedly)</strong>: It modifies the main verb \n        <em>had been postponed</em>, meaning the decision to postpone was unexpected.\n      </li>\n      <li>\n        <strong>Sentence 3 (hit the coast unexpectedly)</strong>: It modifies the verb \n        <em>hit</em>, similar to Sentence 1, placed at the end of the clause.\n      </li>\n    </ul>\n  </li>\n</ul>\n\n<p>\n  Since the parts are present and the core sentence structure \n  <strong>(Subject &rarr; Past Perfect Passive Verb &rarr; Clause)</strong> \n  is maintained, and the adverb can correctly attach to different verbs, all three resulting sentences are grammatically valid interpretations of the parts.\n</p>'),
(53, 'beginner', 'always;They;movies;on Friday;watch', 'They always watch movies on Friday', ''),
(54, 'beginner', 'call;I;you;will;tomorrow evening', 'I will call you tomorrow evening', ''),
(55, 'beginner', 'you;Are;working;right now', 'Are you working right now', ''),
(56, 'beginner', 'is;green;Her favorite color', 'Her favorite color is green', ''),
(57, 'beginner', 'pen;I;Can;your;borrow', 'Can I borrow your pen', ''),
(58, 'beginner', 'here;doesn\'t;He;anymore;live', 'He doesn\'t live here anymore', ''),
(59, 'beginner', 'cooked pizza;Last night;we', 'Last night we cooked pizza', ''),
(60, 'beginner', 'truck;a;red;big;They bought', 'They bought a big red truck', ''),
(61, 'beginner', 'under;The book;the chair;is', 'The book is under the chair', ''),
(62, 'beginner', 'her keys;She;sometimes;forgets', 'She sometimes forgets her keys', ''),
(63, 'beginner', 'the house;in;run;Don\'t', 'Don\'t run in the house', ''),
(64, 'beginner', 'the letter;gave;him;I', 'I gave him the letter', ''),
(65, 'beginner', 'the last one;much better;is;This movie;than', 'This movie is much better than the last one', ''),
(66, 'beginner', 'in the river;very cold;is;The water', 'The water in the river is very cold', ''),
(67, 'beginner', 'but;I must work;I am tired', 'I am tired but I must work;I must work but I am tired', ''),
(68, 'beginner', 'favorite singer;Who;is;your', 'Who is your favorite singer', ''),
(69, 'beginner_exam', 'our grandparents;going to;are;We;visit', 'We are going to visit our grandparents', ''),
(70, 'beginner_exam', 'The TV;the lamp;and;are broken', 'The TV and the lamp are broken', ''),
(71, 'beginner_exam', 'a long nap;took;She;this afternoon', 'She took a long nap this afternoon', ''),
(72, 'beginner_exam', 'drink tea;usually;In the evening;they', 'In the evening they usually drink tea;They usually drink tea in the evening', ''),
(93, 'beginner_exam', 'Although I was tired;I still needed;to finish all;the necessary;paperwork;before the deadline', 'Although I was tired I still needed to finish all the necessary paperwork before the deadline', ''),
(94, 'beginner_exam', 'The heavy rain;unexpectedly caused;the small river;to overflow;its banks;this afternoon', 'The heavy rain unexpectedly caused the small river to overflow its banks this afternoon;The heavy rain caused the small river to unexpectedly overflow its banks this afternoon', ''),
(95, 'beginner_exam', 'The children;quietly gathered;around the;crackling fireplace;to hear;the old story', 'The children quietly gathered around the crackling fireplace to hear the old story;The children gathered quietly around the crackling fireplace to hear the old story', ''),
(96, 'beginner_exam', 'If we leave now;we should;definitely arrive;at the beach;before the;sun goes down', 'If we leave now we should definitely arrive at the beach before the sun goes down', ''),
(97, 'beginner_exam', 'My younger;brother secretly;borrowed my;favorite blue;jacket;without asking;anyone', 'My younger brother secretly borrowed my favorite blue jacket without asking anyone;My younger brother borrowed my favorite blue jacket secretly without asking anyone', ''),
(98, 'beginner_exam', 'We quickly decided;to take a bus;instead of;walking;because it;was raining;hard', 'We quickly decided to take a bus instead of walking because it was raining hard;We decided quickly to take a bus instead of walking because it was raining hard', ''),
(99, 'beginner_exam', 'The ancient ruins;were silently;covered by;thick jungle;vines over;many centuries', 'The ancient ruins were silently covered by thick jungle vines over many centuries;The ancient ruins were covered silently by thick jungle vines over many centuries', ''),
(100, 'beginner_exam', 'She carefully;wrote down;the unfamiliar;phone number;on a small;piece of paper', 'She carefully wrote down the unfamiliar phone number on a small piece of paper;She wrote down carefully the unfamiliar phone number on a small piece of paper', ''),
(101, 'beginner_exam', 'The dedicated;scientist patiently;conducted the;complicated experiment;for three;whole weeks', 'The dedicated scientist patiently conducted the complicated experiment for three whole weeks;The dedicated scientist conducted the complicated experiment patiently for three whole weeks', ''),
(102, 'beginner_exam', 'After the concert;ended, the;huge crowd;started walking;slowly toward;the exit;doors', 'After the concert ended the huge crowd started walking slowly toward the exit doors;After the concert ended the huge crowd slowly started walking toward the exit doors', ''),
(103, 'beginner_exam', 'Every student must;submit their;final project;report to;the teacher;by Friday morning', 'Every student must submit their final project report to the teacher by Friday morning', ''),
(104, 'beginner_exam', 'He politely asked;the customer;to wait;for only;a few;more minutes;outside the store', 'He politely asked the customer to wait for only a few more minutes outside the store;He asked the customer politely to wait for only a few more minutes outside the store', ''),
(105, 'beginner_exam', 'Despite the warnings;the sailors;bravely navigated;their small;boat through;the storm', 'Despite the warnings the sailors bravely navigated their small boat through the storm;Despite the warnings the sailors navigated their small boat bravely through the storm', ''),
(106, 'beginner_exam', 'The strange smell;quickly spread;through the;entire apartment;building;yesterday evening', 'The strange smell quickly spread through the entire apartment building yesterday evening;The strange smell spread quickly through the entire apartment building yesterday evening', ''),
(107, 'beginner_exam', 'It is important;to always read;complex instructions;carefully;before you;begin working', 'It is important to always read complex instructions carefully before you begin working;It is important to read complex instructions carefully always before you begin working', ''),
(108, 'beginner_exam', 'Scientists have;recently discovered;a brand new;type of;insect living;in the;deep cave', 'Scientists have recently discovered a brand new type of insect living in the deep cave;Scientists recently have discovered a brand new type of insect living in the deep cave', ''),
(109, 'beginner_exam', 'The small kitten;happily played;with the;colorful yarn;ball on;the soft rug;all day', 'The small kitten happily played with the colorful yarn ball on the soft rug all day;The small kitten played happily with the colorful yarn ball on the soft rug all day', ''),
(110, 'beginner_exam', 'We realized;immediately that;the difficult;math problem;was actually;missing a;crucial detail', 'We realized immediately that the difficult math problem was actually missing a crucial detail;We immediately realized that the difficult math problem was actually missing a crucial detail', ''),
(111, 'beginner_exam', 'The clever;detective carefully;examined the;scattered clues;found near;the locked;window', 'The clever detective carefully examined the scattered clues found near the locked window;The clever detective examined carefully the scattered clues found near the locked window', ''),
(112, 'beginner_exam', 'They enthusiastically;bought two tickets;for the;popular concert;happening next;Saturday night', 'They enthusiastically bought two tickets for the popular concert happening next Saturday night;They bought two tickets enthusiastically for the popular concert happening next Saturday night', ''),
(213, 'intermediate', 'The car;going down;the road;quickly;is blue', 'The car going down the road quickly is blue;The car quickly going down the road is blue', ''),
(214, 'intermediate', 'She;has been;waiting;at the station;for hours', 'She has been waiting at the station for hours', ''),
(215, 'intermediate', 'They;were;discussing;the new project;very seriously;yesterday', 'They were discussing the new project very seriously yesterday', ''),
(216, 'intermediate', 'The cat;sat;on the wall;watching;the birds', 'The cat sat on the wall watching the birds', ''),
(217, 'intermediate', 'I;will call;you;after;the meeting;finishes', 'I will call you after the meeting finishes', ''),
(218, 'intermediate', 'We;should have;left;the house;earlier;this morning', 'We should have left the house earlier this morning', ''),
(219, 'intermediate', 'The teacher;explained;the lesson;to the students;in detail', 'The teacher explained the lesson to the students in detail', ''),
(220, 'intermediate', 'My parents;are;traveling;to Spain;for vacation;next week', 'My parents are traveling to Spain for vacation next week', ''),
(221, 'intermediate', 'He;couldn\'t;believe;how quickly;the time;had passed', 'He couldn\'t believe how quickly the time had passed', ''),
(222, 'intermediate', 'The child;was playing;with her friends;in the park', 'The child was playing with her friends in the park', ''),
(223, 'intermediate', 'She;didn\'t know;why;the lights;were flickering;last night', 'She didn\'t know why the lights were flickering last night', ''),
(224, 'intermediate', 'We;have been;trying;to fix;the computer;all day', 'We have been trying to fix the computer all day', ''),
(225, 'intermediate', 'The flowers;in the garden;are blooming;so beautifully', 'The flowers in the garden are blooming so beautifully', ''),
(226, 'intermediate', 'I;was surprised;to see;him;at the airport', 'I was surprised to see him at the airport', ''),
(227, 'intermediate', 'The movie;we watched;last night;was extremely;interesting', 'The movie we watched last night was extremely interesting', ''),
(228, 'intermediate', 'She;asked me;to help;her;with the assignment', 'She asked me to help her with the assignment', ''),
(229, 'intermediate', 'They;have lived;in this neighborhood;for over;ten years', 'They have lived in this neighborhood for over ten years', ''),
(230, 'intermediate', 'We;didn\'t realize;how late;it had become;until midnight', 'We didn\'t realize how late it had become until midnight', ''),
(231, 'intermediate', 'The train;arrived;at the station;ten minutes;early', 'The train arrived at the station ten minutes early', ''),
(232, 'intermediate', 'He;was reading;a book;about space;exploration;last night', 'He was reading a book about space exploration last night', ''),
(233, 'intermediate', 'I;forgot;to bring;my umbrella;to work;this morning', 'I forgot to bring my umbrella to work this morning', ''),
(234, 'intermediate', 'They;invited us;to their wedding;in Italy;next summer', 'They invited us to their wedding in Italy next summer', ''),
(235, 'intermediate', 'The dog;was barking;loudly;outside;the neighbor\'s;house', 'The dog was barking loudly outside the neighbor\'s house', ''),
(236, 'intermediate', 'We;were walking;through the forest;when;it started raining', 'We were walking through the forest when it started raining', ''),
(237, 'intermediate', 'The students;were preparing;for the exam;in the library', 'The students were preparing for the exam in the library', ''),
(238, 'intermediate', 'He;didn\'t have;enough time;to finish;his homework', 'He didn\'t have enough time to finish his homework', ''),
(239, 'intermediate', 'The restaurant;we visited;last weekend;was absolutely;amazing', 'The restaurant we visited last weekend was absolutely amazing', ''),
(240, 'intermediate', 'I;haven\'t seen;such a beautiful;sunset;in years', 'I haven\'t seen such a beautiful sunset in years', ''),
(241, 'intermediate', 'She;was wearing;a red dress;that looked;very elegant', 'She was wearing a red dress that looked very elegant', ''),
(242, 'intermediate', 'They;were surprised;by how friendly;the locals;were', 'They were surprised by how friendly the locals were', ''),
(243, 'intermediate', 'The baby;fell asleep;while;listening;to the lullaby', 'The baby fell asleep while listening to the lullaby', ''),
(244, 'intermediate', 'I;was hoping;to meet;you;before;you left', 'I was hoping to meet you before you left', ''),
(245, 'intermediate', 'He;has always;wanted;to learn;how to dance', 'He has always wanted to learn how to dance', ''),
(246, 'intermediate', 'The mountain;was covered;in snow;after;the storm', 'The mountain was covered in snow after the storm', ''),
(247, 'intermediate', 'We;spent the afternoon;walking;along;the riverbank', 'We spent the afternoon walking along the riverbank', ''),
(248, 'intermediate', 'She;found;the letter;hidden;under;the old books', 'She found the letter hidden under the old books', ''),
(249, 'intermediate', 'They;were laughing;about something;that happened;in class', 'They were laughing about something that happened in class', ''),
(250, 'intermediate', 'The cake;smelled delicious;when it;came;out of the oven', 'The cake smelled delicious when it came out of the oven', ''),
(251, 'intermediate', 'I;was told;to wait;until;the doctor;arrived', 'I was told to wait until the doctor arrived', ''),
(252, 'intermediate', 'He;had been;working;on that project;for months', 'He had been working on that project for months', ''),
(253, 'intermediate', 'We;were shocked;to hear;the news;on television', 'We were shocked to hear the news on television', ''),
(254, 'intermediate', 'The weather;was perfect;for a picnic;in the park', 'The weather was perfect for a picnic in the park', ''),
(255, 'intermediate', 'I;didn\'t expect;to see;so many;people there', 'I didn\'t expect to see so many people there', ''),
(256, 'intermediate', 'She;couldn\'t remember;where she;had left;her keys', 'She couldn\'t remember where she had left her keys', ''),
(257, 'intermediate', 'They;decided;to go;for a hike;in the mountains', 'They decided to go for a hike in the mountains', ''),
(258, 'intermediate', 'The man;was fixing;his bicycle;in front of;the house', 'The man was fixing his bicycle in front of the house', ''),
(259, 'intermediate', 'We;were surprised;to find;the shop;still open', 'We were surprised to find the shop still open', ''),
(260, 'intermediate', 'He;asked;for directions;to the nearest;bus station', 'He asked for directions to the nearest bus station', ''),
(261, 'intermediate', 'The concert;was canceled;due to;the heavy rain', 'The concert was canceled due to the heavy rain', ''),
(262, 'intermediate', 'I;will never;forget;the day;we first met', 'I will never forget the day we first met', ''),
(263, 'advanced', 'Although;the evidence;was compelling;the jury;remained unconvinced', 'Although the evidence was compelling the jury remained unconvinced', ''),
(264, 'advanced', 'Had I known;about the delay;I would have;left earlier', 'Had I known about the delay I would have left earlier', ''),
(265, 'advanced', 'She;spoke;so eloquently;that everyone;listened in silence', 'She spoke so eloquently that everyone listened in silence', ''),
(266, 'advanced', 'Despite;being exhausted;he continued;working;until midnight', 'Despite being exhausted he continued working until midnight', ''),
(267, 'advanced', 'No sooner;had we arrived;than the concert;began', 'No sooner had we arrived than the concert began', ''),
(268, 'advanced', 'The proposal;which was submitted;last week;has been;approved', 'The proposal which was submitted last week has been approved', ''),
(269, 'advanced', 'Hardly;had I finished;speaking;when she interrupted;me again', 'Hardly had I finished speaking when she interrupted me again', ''),
(270, 'advanced', 'He acted;as though;he had;never heard;the news before', 'He acted as though he had never heard the news before', ''),
(271, 'advanced', 'Only after;he apologized;did she agree;to forgive him', 'Only after he apologized did she agree to forgive him', ''),
(272, 'advanced', 'By the time;they arrived;the dinner;had already;been served', 'By the time they arrived the dinner had already been served', ''),
(273, 'advanced', 'The book;you lent me;turned out;to be incredibly insightful', 'The book you lent me turned out to be incredibly insightful', ''),
(274, 'advanced', 'Scarcely;had we sat down;when the phone;started ringing', 'Scarcely had we sat down when the phone started ringing', ''),
(275, 'advanced', 'She would have;succeeded;if she had;been given;more support', 'She would have succeeded if she had been given more support', ''),
(276, 'advanced', 'Under no circumstances;should you;open that;sealed envelope', 'Under no circumstances should you open that sealed envelope', ''),
(277, 'advanced', 'It was not;until much later;that he;realized his mistake', 'It was not until much later that he realized his mistake', ''),
(278, 'advanced', 'The manager;insisted that;every report;be completed;before Friday', 'The manager insisted that every report be completed before Friday', ''),
(279, 'advanced', 'He had;barely finished;his meal;when the waiter;asked for payment', 'He had barely finished his meal when the waiter asked for payment', ''),
(280, 'advanced', 'Such;was her confidence;that everyone;believed her instantly', 'Such was her confidence that everyone believed her instantly', ''),
(281, 'advanced', 'Not only;did he lie;to his friends;but also;to his family', 'Not only did he lie to his friends but also to his family', ''),
(282, 'advanced', 'Rarely;have I seen;a performance;so powerful;and moving', 'Rarely have I seen a performance so powerful and moving', ''),
(283, 'advanced', 'He regretted;not having;taken the opportunity;when it arose', 'He regretted not having taken the opportunity when it arose', ''),
(284, 'advanced', 'She had;every reason;to believe;he was telling;the truth', 'She had every reason to believe he was telling the truth', ''),
(285, 'advanced', 'The document;must have been;written;by someone;with authority', 'The document must have been written by someone with authority', ''),
(286, 'advanced', 'Had it not been;for your help;I would have failed', 'Had it not been for your help I would have failed', ''),
(287, 'advanced', 'They couldn\'t decide;whether to stay;or to leave;immediately', 'They couldn\'t decide whether to stay or to leave immediately', ''),
(288, 'advanced', 'He was determined;to prove;that he was;capable of success', 'He was determined to prove that he was capable of success', ''),
(289, 'advanced', 'No matter;how hard;he tried;he couldn\'t finish;the puzzle', 'No matter how hard he tried he couldn\'t finish the puzzle', ''),
(290, 'advanced', 'The committee;having discussed;the matter;reached;a unanimous decision', 'The committee having discussed the matter reached a unanimous decision', ''),
(291, 'advanced', 'She might have;called earlier;if she had;known the situation', 'She might have called earlier if she had known the situation', ''),
(292, 'advanced', 'Barely;had the sun risen;when the birds;started singing', 'Barely had the sun risen when the birds started singing', ''),
(293, 'advanced', 'The report;though incomplete;provided;valuable insights;into the issue', 'The report though incomplete provided valuable insights into the issue', ''),
(294, 'advanced', 'He kept talking;as if;nothing unusual;had happened', 'He kept talking as if nothing unusual had happened', ''),
(295, 'advanced', 'Seldom;do people;appreciate;the value of;time until it\'s gone', 'Seldom do people appreciate the value of time until it\'s gone', ''),
(296, 'advanced', 'The new law;was implemented;to address;environmental concerns', 'The new law was implemented to address environmental concerns', ''),
(297, 'advanced', 'He will continue;working here;provided that;the conditions improve', 'He will continue working here provided that the conditions improve', ''),
(298, 'advanced', 'The results;having been analyzed;were published;in the journal', 'The results having been analyzed were published in the journal', ''),
(299, 'advanced', 'I would rather;you didn\'t;mention this;to anyone;else', 'I would rather you didn\'t mention this to anyone else', ''),
(300, 'advanced', 'Only if;we act now;can we;prevent further damage', 'Only if we act now can we prevent further damage', ''),
(301, 'advanced', 'She couldn\'t help;wondering;what might have happened;if she stayed', 'She couldn\'t help wondering what might have happened if she stayed', ''),
(302, 'advanced', 'As soon as;the lights went out;the audience;started screaming', 'As soon as the lights went out the audience started screaming', ''),
(303, 'advanced', 'Not until;he apologized;did they;decide to;trust him again', 'Not until he apologized did they decide to trust him again', ''),
(304, 'advanced', 'Were I;in your position;I would;make a different decision', 'Were I in your position I would make a different decision', ''),
(305, 'advanced', 'The scientist;who discovered;the formula;was later;awarded a prize', 'The scientist who discovered the formula was later awarded a prize', ''),
(306, 'advanced', 'Having completed;the training;she felt;more confident;in her skills', 'Having completed the training she felt more confident in her skills', ''),
(307, 'advanced', 'Should you;need assistance;do not hesitate;to contact us', 'Should you need assistance do not hesitate to contact us', ''),
(308, 'advanced', 'Little did;she know;that her words;would change everything', 'Little did she know that her words would change everything', ''),
(309, 'advanced', 'Provided that;you follow;the instructions;you should succeed', 'Provided that you follow the instructions you should succeed', ''),
(310, 'advanced', 'He apologized;for not being;able to attend;the ceremony', 'He apologized for not being able to attend the ceremony', ''),
(311, 'advanced', 'If only;she had listened;to his advice;things would differ', 'If only she had listened to his advice things would differ', ''),
(312, 'advanced', 'The conference;which was held;in Geneva;focused on global security', 'The conference which was held in Geneva focused on global security', ''),
(313, 'advanced', 'The painting;believed to be;centuries old;was finally restored', 'The painting believed to be centuries old was finally restored', ''),
(314, 'intermediate_exam', 'If I had known;about the meeting;I would have;prepared better', 'If I had known about the meeting I would have prepared better', ''),
(315, 'intermediate_exam', 'She;wasn\'t sure;whether;to accept;the job offer;or not', 'She wasn\'t sure whether to accept the job offer or not', ''),
(316, 'intermediate_exam', 'The film;we watched;last weekend;was based;on a true story', 'The film we watched last weekend was based on a true story', ''),
(317, 'intermediate_exam', 'They;had already;left;by the time;we arrived;at the station', 'They had already left by the time we arrived at the station', ''),
(318, 'intermediate_exam', 'Although;it was raining;we decided;to go;for a walk', 'Although it was raining we decided to go for a walk', ''),
(319, 'intermediate_exam', 'He;didn\'t remember;where he;had placed;his passport', 'He didn\'t remember where he had placed his passport', ''),
(320, 'intermediate_exam', 'The restaurant;that opened;last month;has become;very popular', 'The restaurant that opened last month has become very popular', ''),
(321, 'intermediate_exam', 'She;kept studying;until;she finally;understood;the concept', 'She kept studying until she finally understood the concept', ''),
(322, 'intermediate_exam', 'I;don\'t know;how she managed;to finish;that report;so quickly', 'I don\'t know how she managed to finish that report so quickly', ''),
(323, 'intermediate_exam', 'He;was late;because;his car;had broken down;on the way', 'He was late because his car had broken down on the way', ''),
(324, 'intermediate_exam', 'The person;who called;you yesterday;wants to;meet tomorrow', 'The person who called you yesterday wants to meet tomorrow', ''),
(325, 'intermediate_exam', 'We;were surprised;by how;beautiful;the city looked;at night', 'We were surprised by how beautiful the city looked at night', ''),
(326, 'intermediate_exam', 'The teacher;expected;the students;to submit;their projects;on time', 'The teacher expected the students to submit their projects on time', ''),
(327, 'intermediate_exam', 'I;hadn\'t realized;how important;that document;was;until now', 'I hadn\'t realized how important that document was until now', ''),
(328, 'intermediate_exam', 'She;couldn\'t decide;which dress;to wear;for the occasion', 'She couldn\'t decide which dress to wear for the occasion', ''),
(329, 'intermediate_exam', 'The book;that I borrowed;from the library;was very helpful', 'The book that I borrowed from the library was very helpful', ''),
(330, 'intermediate_exam', 'By the time;the movie started;the seats;were already taken', 'By the time the movie started the seats were already taken', ''),
(331, 'intermediate_exam', 'We;didn\'t know;what to do;after;the power went out', 'We didn\'t know what to do after the power went out', ''),
(332, 'intermediate_exam', 'If you;had told me;earlier;I could have;helped you', 'If you had told me earlier I could have helped you', ''),
(333, 'intermediate_exam', 'He;had been;waiting for hours;before;the bus finally arrived', 'He had been waiting for hours before the bus finally arrived', ''),
(334, 'intermediate_exam', 'The meeting;was postponed;due to;unexpected;weather conditions', 'The meeting was postponed due to unexpected weather conditions', ''),
(335, 'intermediate_exam', 'We;were relieved;to hear;that everyone;was safe;after the storm', 'We were relieved to hear that everyone was safe after the storm', ''),
(336, 'intermediate_exam', 'They;were disappointed;because;the concert;was canceled;at the last minute', 'They were disappointed because the concert was canceled at the last minute', ''),
(337, 'intermediate_exam', 'It;wasn\'t until;I saw the photo;that I;recognized him', 'It wasn\'t until I saw the photo that I recognized him', ''),
(338, 'intermediate_exam', 'The plan;was approved;after;several revisions;and discussions', 'The plan was approved after several revisions and discussions', ''),
(339, 'intermediate_exam', 'He;was confident;that his team;would win;the final match', 'He was confident that his team would win the final match', ''),
(340, 'intermediate_exam', 'She;had already;finished;her assignment;before;the deadline', 'She had already finished her assignment before the deadline', ''),
(341, 'intermediate_exam', 'The letter;that arrived;yesterday;contained;some surprising news', 'The letter that arrived yesterday contained some surprising news', ''),
(342, 'intermediate_exam', 'I;wasn\'t expecting;him to;show up;unannounced;at my house', 'I wasn\'t expecting him to show up unannounced at my house', ''),
(343, 'intermediate_exam', 'He;apologized;for not being;able to;attend the ceremony', 'He apologized for not being able to attend the ceremony', ''),
(344, 'intermediate_exam', 'They;spent the weekend;repairing;the roof;before the storm', 'They spent the weekend repairing the roof before the storm', ''),
(345, 'intermediate_exam', 'We;couldn\'t believe;how much;the city;had changed;in ten years', 'We couldn\'t believe how much the city had changed in ten years', ''),
(346, 'intermediate_exam', 'The children;were excited;to see;the fireworks;in the sky', 'The children were excited to see the fireworks in the sky', ''),
(347, 'intermediate_exam', 'He;kept asking;if I;had already;finished the report', 'He kept asking if I had already finished the report', ''),
(348, 'intermediate_exam', 'The manager;was surprised;that nobody;had noticed;the mistake', 'The manager was surprised that nobody had noticed the mistake', ''),
(349, 'intermediate_exam', 'She;didn\'t know;why the door;was left;unlocked;overnight', 'She didn\'t know why the door was left unlocked overnight', ''),
(350, 'intermediate_exam', 'I;had planned;to go;on vacation;before;the project started', 'I had planned to go on vacation before the project started', ''),
(351, 'intermediate_exam', 'The museum;was closed;for renovations;when we visited;last month', 'The museum was closed for renovations when we visited last month', ''),
(352, 'intermediate_exam', 'We;were told;to arrive;early;for the morning session', 'We were told to arrive early for the morning session', ''),
(353, 'intermediate_exam', 'He;was hoping;to be promoted;after completing;the training course', 'He was hoping to be promoted after completing the training course', ''),
(354, 'intermediate_exam', 'The woman;who lives;next door;has been;very kind;to us', 'The woman who lives next door has been very kind to us', ''),
(355, 'intermediate_exam', 'They;had been;discussing;the issue;for hours;without a result', 'They had been discussing the issue for hours without a result', ''),
(356, 'intermediate_exam', 'She;had never;seen a painting;as beautiful;as that one', 'She had never seen a painting as beautiful as that one', ''),
(357, 'intermediate_exam', 'We;didn\'t expect;the weather;to change;so suddenly;this afternoon', 'We didn\'t expect the weather to change so suddenly this afternoon', ''),
(358, 'intermediate_exam', 'The report;that he submitted;was detailed;and well organized', 'The report that he submitted was detailed and well organized', ''),
(359, 'intermediate_exam', 'He;had no idea;that she;was planning;a surprise party', 'He had no idea that she was planning a surprise party', ''),
(360, 'intermediate_exam', 'I;should have;taken your advice;when I had;the chance', 'I should have taken your advice when I had the chance', ''),
(361, 'intermediate_exam', 'They;arrived late;because;their flight;had been delayed', 'They arrived late because their flight had been delayed', ''),
(362, 'intermediate_exam', 'We;were told;that the store;would reopen;the following day', 'We were told that the store would reopen the following day', ''),
(363, 'intermediate_exam', 'She;didn\'t realize;that her phone;had been;stolen;at the event', 'She didn\'t realize that her phone had been stolen at the event', ''),
(364, 'intermediate_exam', 'He;had worked;so hard;that he;fell asleep;immediately after', 'He had worked so hard that he fell asleep immediately after', ''),
(365, 'advanced_exam', 'The car;going down;the road;quickly;is blue', 'The car going down the road quickly is blue;The car quickly going down the road is blue', ''),
(366, 'advanced_exam', 'When I;arrived;at the station;the train;had already left', 'When I arrived at the station the train had already left', ''),
(367, 'advanced_exam', 'If she;had studied;more carefully;she;would have passed;the exam', 'If she had studied more carefully she would have passed the exam', ''),
(368, 'advanced_exam', 'The man;who lives;next door;plays;the violin;beautifully;every evening', 'The man who lives next door plays the violin beautifully every evening', ''),
(369, 'advanced_exam', 'Despite the rain;we;decided;to continue;our walk;through the park', 'Despite the rain we decided to continue our walk through the park', ''),
(370, 'advanced_exam', 'She;did not realize;how much;her words;affected;everyone;in the room', 'She did not realize how much her words affected everyone in the room', ''),
(371, 'advanced_exam', 'Had I;known;about the meeting;I;would have prepared;something to say', 'Had I known about the meeting I would have prepared something to say', ''),
(372, 'advanced_exam', 'While they;were discussing;the proposal;someone;interrupted;them suddenly', 'While they were discussing the proposal someone interrupted them suddenly', ''),
(373, 'advanced_exam', 'The teacher;asked;that we;submit;our assignments;before;the weekend', 'The teacher asked that we submit our assignments before the weekend', ''),
(374, 'advanced_exam', 'The building;that was constructed;in 1920;has been;recently renovated', 'The building that was constructed in 1920 has been recently renovated', ''),
(375, 'advanced_exam', 'Although he;was tired;he;continued;working;until midnight', 'Although he was tired he continued working until midnight', ''),
(376, 'advanced_exam', 'By the time;we arrived;at the hotel;the others;had already eaten', 'By the time we arrived at the hotel the others had already eaten', ''),
(377, 'advanced_exam', 'The document;you sent;contains;some errors;that need;to be corrected', 'The document you sent contains some errors that need to be corrected', ''),
(378, 'advanced_exam', 'Since you;are responsible;for the project;you;should attend;the meeting', 'Since you are responsible for the project you should attend the meeting', ''),
(379, 'advanced_exam', 'No sooner;had we;reached the airport;than;it started raining', 'No sooner had we reached the airport than it started raining', ''),
(380, 'advanced_exam', 'The book;that I;borrowed from you;was;extremely interesting', 'The book that I borrowed from you was extremely interesting', ''),
(381, 'advanced_exam', 'Unless you;finish your work;on time;you;cannot join;the party', 'Unless you finish your work on time you cannot join the party', ''),
(382, 'advanced_exam', 'She;was surprised;to find;her old friend;waiting;at the cafe', 'She was surprised to find her old friend waiting at the cafe', ''),
(383, 'advanced_exam', 'The scientist;who discovered;the new element;was awarded;a major prize', 'The scientist who discovered the new element was awarded a major prize', ''),
(384, 'advanced_exam', 'Before we;make any decisions;we;should consult;with the manager', 'Before we make any decisions we should consult with the manager', ''),
(385, 'advanced_exam', 'I;have been;trying;to reach you;since yesterday;afternoon', 'I have been trying to reach you since yesterday afternoon', ''),
(386, 'advanced_exam', 'The company;plans;to launch;a new product;early next year', 'The company plans to launch a new product early next year', ''),
(387, 'advanced_exam', 'Because he;spoke so quietly;we;could not;understand him clearly', 'Because he spoke so quietly we could not understand him clearly', ''),
(388, 'advanced_exam', 'She promised;that she;would call;as soon as;she arrived;home', 'She promised that she would call as soon as she arrived home', ''),
(389, 'advanced_exam', 'If I;had known;how difficult;it would be;I;would have stayed', 'If I had known how difficult it would be I would have stayed', ''),
(390, 'advanced_exam', 'He;was accused;of stealing;documents;from the company;last month', 'He was accused of stealing documents from the company last month', ''),
(391, 'advanced_exam', 'We;expected;that the results;would be;announced;by Friday', 'We expected that the results would be announced by Friday', ''),
(392, 'advanced_exam', 'The woman;wearing the red dress;spoke;confidently;to the audience', 'The woman wearing the red dress spoke confidently to the audience', ''),
(393, 'advanced_exam', 'If you;had arrived;earlier;you;could have met;the director', 'If you had arrived earlier you could have met the director', '');
INSERT INTO `sentence_form` (`id`, `level`, `parts`, `answers`, `info`) VALUES
(394, 'advanced_exam', 'Although the task;was challenging;they;managed;to complete it', 'Although the task was challenging they managed to complete it', ''),
(395, 'advanced_exam', 'The movie;that we watched;last night;was;based on;a true story', 'The movie that we watched last night was based on a true story', ''),
(396, 'advanced_exam', 'He claimed;that he;had been;working;on the project;for months', 'He claimed that he had been working on the project for months', ''),
(397, 'advanced_exam', 'Before you;submit;your report;please;check;for spelling errors', 'Before you submit your report please check for spelling errors', ''),
(398, 'advanced_exam', 'We;were informed;that the event;had been;postponed;due to weather', 'We were informed that the event had been postponed due to weather', ''),
(399, 'advanced_exam', 'The letter;that arrived;yesterday;contained;important information', 'The letter that arrived yesterday contained important information', ''),
(400, 'advanced_exam', 'If I;were you;I;would not;take such;a big risk', 'If I were you I would not take such a big risk', ''),
(401, 'advanced_exam', 'They;had already left;by the time;we reached;the venue', 'They had already left by the time we reached the venue', ''),
(402, 'advanced_exam', 'Because the presentation;was delayed;we;missed;the final discussion', 'Because the presentation was delayed we missed the final discussion', ''),
(403, 'advanced_exam', 'She;was pleased;to hear;that her application;had been accepted', 'She was pleased to hear that her application had been accepted', ''),
(404, 'advanced_exam', 'The house;that stands;on the hill;belongs;to my grandparents', 'The house that stands on the hill belongs to my grandparents', ''),
(405, 'advanced_exam', 'He;did not know;that the store;had closed;for renovation', 'He did not know that the store had closed for renovation', ''),
(406, 'advanced_exam', 'After they;had eaten;dinner;they;went for;a long walk', 'After they had eaten dinner they went for a long walk', ''),
(407, 'advanced_exam', 'It was;so dark;that we;could barely;see the path ahead', 'It was so dark that we could barely see the path ahead', ''),
(408, 'advanced_exam', 'Unless the weather;improves soon;we;will have;to cancel;the trip', 'Unless the weather improves soon we will have to cancel the trip', ''),
(409, 'advanced_exam', 'She;could not believe;what she;saw;when she entered;the room', 'She could not believe what she saw when she entered the room', ''),
(410, 'advanced_exam', 'Even though;he apologized;sincerely;she;did not;forgive him', 'Even though he apologized sincerely she did not forgive him', ''),
(411, 'advanced_exam', 'If we;had known;there was traffic;we;would have left earlier', 'If we had known there was traffic we would have left earlier', ''),
(412, 'advanced_exam', 'The student;who studies;diligently;always;achieves;excellent results', 'The student who studies diligently always achieves excellent results', ''),
(413, 'advanced_exam', 'They;had been;waiting;for more than;two hours;before boarding', 'They had been waiting for more than two hours before boarding', ''),
(414, 'advanced_exam', 'Because she;was running late;she;skipped;breakfast;that morning', 'Because she was running late she skipped breakfast that morning', ''),
(415, 'advanced_exam', 'We;did not realize;how quickly;the time;had passed;that evening', 'We did not realize how quickly the time had passed that evening', ''),
(416, 'advanced_exam', 'Although it;was expensive;they;decided;to buy;the painting anyway', 'Although it was expensive they decided to buy the painting anyway', ''),
(417, 'level_exam', 'Many;flights;abroad;had;to be;canceled;due to;the bad weather', 'Many flights abroad had to be canceled due to the bad weather', '<p>   From the provided word parts—<strong>\"Many\"</strong>, <strong>\"flights\"</strong>,    <strong>\"abroad\"</strong>, <strong>\"had\"</strong>, <strong>\"to be\"</strong>,    <strong>\"canceled\"</strong>, <strong>\"due to\"</strong>, and    <strong>\"the bad weather\"</strong>—only one grammatically valid and meaningful sentence can be formed:   <strong>\"Many flights abroad had to be canceled due to the bad weather.\"</strong> </p>  <ul>   <li>     <strong>Many flights</strong>: This forms the complete      <strong>Subject Noun Phrase</strong>.       <ul>       <li><strong>Many</strong>: determiner / quantifier.</li>       <li><strong>flights</strong>: head noun.</li>     </ul>   </li>    <li>     <strong>abroad</strong>: An <strong>adverb</strong> that modifies      <em>flights</em> by specifying their type or destination.       It cannot function as a verb, complement, or conjunction, so it must attach to the noun phrase as in      <em>\"flights abroad.\"</em>   </li>    <li>     <strong>had to be canceled</strong>: A complete and correctly ordered      <strong>modal-like passive verb phrase</strong>.       <ul>       <li><strong>had to</strong>: expresses necessity / obligation.</li>       <li><strong>be canceled</strong>: passive infinitive indicating what had to happen.</li>     </ul>     These components have a fixed internal order; rearranging them produces ungrammatical strings      (e.g., <em>\"to be had canceled\"</em> or <em>\"had canceled to be\"</em>).   </li>    <li>     <strong>due to the bad weather</strong>: A      <strong>prepositional phrase of cause</strong>.     <ul>       <li><strong>due to</strong>: a preposition that must be followed by a noun phrase.</li>       <li><strong>the bad weather</strong>: the required noun phrase object.</li>     </ul>     This entire phrase cannot be split or reordered meaningfully with the other parts.   </li> </ul>  <p>   Because each component has a fixed grammatical function and only one syntactic slot where it can logically appear,    the sentence must follow the structure     <strong>Subject → Verb Phrase → Cause Phrase</strong>.     Any alternative ordering (for example, starting with <em>\"Due to many flights...\"</em> or placing <em>\"abroad\"</em> inside the verb phrase) results in an ungrammatical or nonsensical sentence.     Therefore, <strong>\"Many flights abroad had to be canceled due to the bad weather\"</strong> is the only valid formation using all the given parts. </p>'),
(418, 'level_exam', 'Each;and;every person;carried;their;own bag;,;which;weighed;less;than;fifty;kilograms', 'Each and every person carried their own bag, which weighed less than fifty kilograms', '<p>   From the provided parts—<strong>\"Each\"</strong>, <strong>\"and\"</strong>,    <strong>\"every person\"</strong>, <strong>\"carried\"</strong>, <strong>\"their\"</strong>,    <strong>\"own bag\"</strong>, <strong>\",\"</strong>, <strong>\"which\"</strong>,    <strong>\"weighed\"</strong>, <strong>\"less\"</strong>, <strong>\"than\"</strong>,    <strong>\"fifty\"</strong>, <strong>\"kilograms\"</strong>—only one fully grammatical and meaningful sentence can be formed:   <strong>\"Each and every person carried their own bag, which weighed less than fifty kilograms.\"</strong> </p>  <ul>   <li>     <strong>Each and every person</strong>: The complete      <strong>Subject Noun Phrase</strong>.     <ul>       <li><strong>Each and every</strong>: a fixed emphatic determiner pair;            the order cannot be reversed (<em>\"every and each person\"</em> is not idiomatic).</li>       <li><strong>person</strong>: head noun.</li>     </ul>   </li>    <li>     <strong>carried</strong>: The main verb in the      <strong>simple past tense</strong>.       It must immediately follow the subject to form the clause      <em>\"Each and every person carried...\"</em>   </li>    <li>     <strong>their own bag</strong>: The      <strong>object noun phrase</strong>.     <ul>       <li><strong>their</strong>: possessive determiner coreferential with            <em>person</em>, acceptable as a singular generic pronoun.</li>       <li><strong>own bag</strong>: the noun phrase functioning as the direct object of <em>carried</em>.</li>     </ul>   </li>    <li>     <strong>, which weighed less than fifty kilograms</strong>: A      <strong>non-restrictive relative clause</strong> introduced by a required comma.     <ul>       <li><strong>which</strong>: relative pronoun referring to <em>bag</em>.</li>       <li><strong>weighed</strong>: verb of the relative clause.</li>       <li><strong>less than fifty kilograms</strong>: comparative adverbial phrase indicating weight.</li>     </ul>   </li> </ul>  <p>   The relative clause must follow the noun it modifies (<em>bag</em>), and the comparative phrase    <strong>\"less than fifty kilograms\"</strong> has a fixed internal order that cannot be rearranged    (<em>\"fifty kilograms less than\"</em> or <em>\"less fifty than kilograms\"</em> are ungrammatical).     Likewise, the sequence <strong>\"Each and every\"</strong> and the noun phrase    <strong>\"their own bag\"</strong> cannot be split or reordered.     Because each component has only one syntactically valid position, the sentence    <strong>\"Each and every person carried their own bag, which weighed less than fifty kilograms\"</strong>    is the only grammatically correct arrangement of all the given parts. </p>'),
(419, 'level_exam', 'No one;deserves;a;longer;vacation;than;an;honest;worker', 'No one deserves a longer vacation than an honest worker', '<p>   From the provided parts—<strong>\"No one\"</strong>, <strong>\"deserves\"</strong>,    <strong>\"a\"</strong>, <strong>\"longer\"</strong>, <strong>\"vacation\"</strong>,    <strong>\"than\"</strong>, <strong>\"an\"</strong>, <strong>\"honest\"</strong>,    <strong>\"worker\"</strong>—only one grammatical and meaningful sentence can be formed:   <strong>\"No one deserves a longer vacation than an honest worker.\"</strong> </p>  <ul>   <li>     <strong>No one</strong>: The complete      <strong>Subject</strong>.     <ul>       <li>A fixed negative pronoun meaning “nobody.”             It cannot be rearranged or combined with other determiners.</li>     </ul>   </li>    <li>     <strong>deserves</strong>: The      <strong>main verb</strong> in the simple present.       It must directly follow the subject to form the core clause      <em>\"No one deserves...\"</em>   </li>    <li>     <strong>a longer vacation</strong>: The      <strong>object noun phrase</strong>.     <ul>       <li><strong>a</strong>: determiner.</li>       <li><strong>longer</strong>: comparative adjective modifying <em>vacation</em>.</li>       <li><strong>vacation</strong>: head noun.</li>     </ul>     These elements have a fixed internal order; rearranging them yields ungrammatical sequences      (e.g., <em>\"vacation longer a\"</em>, <em>\"a vacation longer\"</em> in this specific structure).   </li>    <li>     <strong>than an honest worker</strong>: A      <strong>comparative complement</strong> required by the comparative adjective <em>longer</em>.     <ul>       <li><strong>than</strong>: introduces the comparison.</li>       <li><strong>an honest worker</strong>: noun phrase that completes the comparison.         <ul>           <li><strong>an</strong>: determiner.</li>           <li><strong>honest</strong>: adjective.</li>           <li><strong>worker</strong>: head noun.</li>         </ul>       </li>     </ul>     This phrase must follow the object noun phrase and cannot appear elsewhere without breaking the comparative structure.   </li> </ul>  <p>   Because each component has a rigid syntactic role—subject → verb → object → comparative complement—   and none of the noun phrases or the comparative marker can be reordered or separated meaningfully,    the sentence <strong>\"No one deserves a longer vacation than an honest worker\"</strong>    is the <em>only</em> valid arrangement of all the given parts. </p>'),
(420, 'level_exam', 'Having completed;the exam;the;,;student;had;discovered;his;mistake', 'Having completed the exam, the student had discovered his mistake', '<p>   From the provided parts—<strong>\"Having completed\"</strong>,    <strong>\"the exam\"</strong>, <strong>\"the\"</strong>, <strong>\",\"</strong>,    <strong>\"student\"</strong>, <strong>\"had\"</strong>, <strong>\"discovered\"</strong>,    <strong>\"his\"</strong>, <strong>\"mistake\"</strong>—only one grammatically valid, meaningful sentence can be formed:   <strong>\"Having completed the exam, the student had discovered his mistake.\"</strong> </p>  <ul>   <li>     <strong>Having completed the exam</strong>: A      <strong>perfect participial clause</strong> functioning as an adverbial phrase.     <ul>       <li><strong>Having completed</strong>: perfect participle indicating an action            finished before the main clause.</li>       <li><strong>the exam</strong>: object of <em>completed</em>.</li>       <li>This clause must appear before the comma; placing it elsewhere produces            either ambiguity or ungrammaticality.</li>     </ul>   </li>    <li>     <strong>,</strong>: The required comma separating the participial phrase      from the main clause.     <br>     Without the comma, the sentence would violate standard English punctuation norms      for introductory participial clauses.   </li>    <li>     <strong>the student</strong>: The      <strong>subject</strong> of the main clause.     <ul>       <li><strong>the</strong>: determiner.</li>       <li><strong>student</strong>: head noun.</li>       <li>This phrase must follow the participial clause because the subject of that clause            must be the same as the subject of the main clause.</li>     </ul>   </li>    <li>     <strong>had discovered</strong>: The      <strong>past perfect verb phrase</strong> of the main clause.     <ul>       <li><strong>had</strong>: auxiliary.</li>       <li><strong>discovered</strong>: past participle.</li>       <li>This ordering is fixed; alternatives such as <em>\"discovered had\"</em> are impossible.</li>     </ul>   </li>    <li>     <strong>his mistake</strong>: The      <strong>object noun phrase</strong> of the verb.     <ul>       <li><strong>his</strong>: possessive determiner.</li>       <li><strong>mistake</strong>: head noun.</li>     </ul>   </li> </ul>  <p>   Because the participial clause must precede the main clause, the main clause must include the    subject–auxiliary–participle sequence <strong>the student had discovered</strong>, and the object    <strong>his mistake</strong> can only appear at the end, there is exactly one syntactically valid way    to assemble all the given parts.     Therefore, <strong>\"Having completed the exam, the student had discovered his mistake.\"</strong> is the    only possible grammatical sentence that can be formed. </p>');

-- --------------------------------------------------------

--
-- Table structure for table `spelling`
--

CREATE TABLE `spelling` (
  `id` int(9) NOT NULL,
  `level` varchar(17) NOT NULL,
  `question` varchar(200) NOT NULL,
  `answer` varchar(30) NOT NULL,
  `info` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `spelling`
--

INSERT INTO `spelling` (`id`, `level`, `question`, `answer`, `info`) VALUES
(1, 'beginner', 'We ride these to go to far-away places. They are found at an airport.', 'plane', 'The *plane* is landing'),
(2, 'beginner', 'It is found in parks. It has water shooting up or falling down.', 'fountain', 'The *fountain* is gorgeous.'),
(3, 'beginner', 'To choose, often from a list of options.', 'select', 'Please *select* a channel.'),
(4, 'beginner', 'The period of the day when it\'s dark and most people sleep.', 'night', 'It gets dark at *night*.'),
(5, 'beginner', 'It describes something as very beautiful.', 'gorgeous', 'Her dress was *gorgeous*.'),
(6, 'beginner', 'A person who serves food and drinks in a restaurant. They wait your table.', 'waiter', 'The *waiter* gave us our food.'),
(7, 'beginner', 'To have a good amount of something. It means you don\'t want any more.', 'enough', 'I think that\'s *enough*.'),
(8, 'beginner', 'To copy or act like something or someone else.', 'imitate', 'I like to *imitate* actors.'),
(9, 'beginner', 'This means that something is needed.', 'necessary', 'I think it\'s *necessary*.'),
(10, 'beginner', 'It means to happen every week, month, day, or year - like events or competitions.', 'annual', 'The fiesta happens *annually*.'),
(11, 'beginner', '../AUDIOS/Spelling/Beginner/word_beginner_1.wav', 'palaces', 'Royals live in *palaces*.'),
(12, 'beginner', '../AUDIOS/Spelling/Beginner/word_beginner_2.wav', 'alright', 'I\'m *alright*!'),
(13, 'beginner', '../AUDIOS/Spelling/Beginner/word_beginner_3.wav', 'receive', 'I didn\'t *receive* your gift.'),
(14, 'level_exam', '../AUDIOS/Spelling/Level_exam/word_level_exam_1.wav', 'maintenance', 'The park\'s closed for *maintenance*.'),
(15, 'level_exam', '../AUDIOS/Spelling/Level_exam/word_level_exam_2.wav', 'embarrassing', 'It\'s *embarrassing* to go out like this.'),
(16, 'level_exam', '../AUDIOS/Spelling/Level_exam/word_level_exam_3.wav', 'hierarchy', 'Nature has its own special *hierarchy*.'),
(17, 'intermediate', 'It can refer to an event, often celebrated, or a moment in time.', 'occasion', 'It is a special *occasion*.'),
(18, 'beginner', 'It is the second month in a year.', 'february', 'Valentine\'s Day is in *February*.'),
(19, 'intermediate', 'It refers to high skill or someone\'s occupation.', 'professional', 'He is a real *professional*.'),
(20, 'intermediate', 'It is how you view something, often referring to life or your worldview.', 'perceive', 'I *perceive* view things differently.'),
(21, 'beginner', 'It is the day after Monday.', 'tuesday', 'The event\'s on *Tuesday*, right?'),
(22, 'advanced', 'It refers to the hobby or object that is made by stitching thread onto canvas or a piece of fabric.', 'embroidery', 'My grandma loves *embroidery*.'),
(23, 'intermediate', 'The Bluetooth device is connected-uh _________.', 'successfully', 'It connected *successfully*.'),
(24, 'intermediate', 'It refers to someone (or the act of being) next in line, such as in a job position or noble families.', 'successor', 'I am his true *successor*.'),
(25, 'intermediate', 'It refers to someone or a family that is high in status, or good.', 'noble', 'They are a *noble* family.'),
(26, 'intermediate', 'It means to make someone feel welcome or adjust to someone/something\'s needs.', 'accommodate', 'Try to *accommodate* him.'),
(27, 'intermediate', 'It refers to something that is right for the moment or for an event. (e.g. attire).', 'appropriate', 'You should wear the *appropriate* clothing.'),
(28, 'beginner', 'It is something pretty.', 'beautiful', 'It is very *beautiful*.'),
(29, 'intermediate', 'It is the act of showing gratitude.', 'appreciation', 'It is a symbol of my *appreciation*.'),
(30, 'intermediate', 'It is an official way to refer to a group of higher-ups, such as in sports or planning.', 'committee', 'The *committee* met yesterday.'),
(31, 'intermediate', 'It refers to something that bothers or annoys people.', 'nuisance', 'He is a public *nuisance*.'),
(32, 'beginner', 'It is a task done at home, such as cleaning or washing the dishes.', 'chore', 'I hate *chores*.'),
(33, 'beginner', 'It usually refers to the people who sing in a church.', 'choir', 'The *choir* sounds lovely.'),
(34, 'advanced', 'It comes French, meaning \"goodbye\" or \"farewell\". Usually prefaced by the words \"I bid you...\"', 'adieu', 'I bid you *adieu*.'),
(35, 'beginner', 'It is below the roof, but above your head.', 'ceiling', 'Gullible is written on the *ceiling*.'),
(36, 'intermediate', 'It is something extra to be added to something, like for bikes, or files in an email.', 'attachment', 'I\'ve sent the *attachment*.'),
(37, 'advanced', 'It is one of the states in the USA, with a river of the same name, and notoriously difficult to spell.', 'Mississippi', 'I would like to go to *Mississippi*.'),
(38, 'advanced', 'Something famous, but in a slightly controversial way.', 'notorious', 'He is *notorious* for not paying.'),
(39, 'advanced', 'It is a retelling of a person\'s life, usually printed, with an emotional emphasis.', 'memoir', 'He finally published his *memoir*.'),
(40, 'intermediate', 'It refers to a ruler of Ancient Egypt.', 'pharaoh', 'The pyramid was built by the *pharaoh*.'),
(41, 'advanced', 'Close bond or connection, or someone who maintains a connection between people.', 'liason', 'He was suspected of *liaison*.'),
(42, 'advanced', 'It refers to words that are spelled to resemble or illustrate sounds.', 'onomatopoeia', '\'Brrr\' is *onomatopoeia*.'),
(43, 'intermediate', 'The \'B\' in BIR.', 'bureau', 'It is the *Bureau* of Internal Revenue.'),
(44, 'intermediate', '[American spelling] It gives you permission to do something, or is proof that you are something (for example a driver, a nurse, etc). ', 'license', 'I have a driver\'s *license*.'),
(45, 'intermediate', 'This means someone is unaware.', 'oblivious', 'He is *oblivious*.'),
(46, 'advanced', 'It describes something that is not clear, or could be one or the other.', 'ambiguous', 'The results are *ambiguous*.'),
(47, 'beginner', 'It is something you buy or take to remember a trip or an event.', 'souvenir', 'I love *souvenirs*!'),
(48, 'beginner_exam', 'The reason why something happens.', 'because', 'She was happy *because* it was Friday.'),
(49, 'beginner_exam', 'A person you like and know well.', 'friend', 'My *friend* and I play soccer together.'),
(51, 'beginner_exam', 'Doing something as a group.', 'together', 'We worked *together* to finish the project.'),
(52, 'beginner_exam', 'More than one person.', 'people', 'There were many *people* waiting for the bus.'),
(53, 'beginner_exam', 'Belonging to them.', 'their', 'The students finished *their* homework.'),
(54, 'beginner_exam', 'To have information or understanding.', 'know', 'Do you *know* the answer to this question?'),
(55, 'beginner_exam', 'To be certain or definite about something.', 'sure', 'I am *sure* the store is open until 9 PM.'),
(56, 'beginner_exam', 'Very pretty or lovely.', 'beautiful', 'The sunset over the ocean was *beautiful*.'),
(57, 'beginner_exam', 'To get something that is sent to you.', 'receive', 'Did you *receive* the package I mailed?'),
(58, 'beginner_exam', 'A chart showing days, weeks, and months.', 'calendar', 'I wrote the appointment on my *calendar*.'),
(59, 'beginner_exam', 'The day after today.', 'tomorrow', 'We will meet for lunch *tomorrow* afternoon.'),
(60, 'beginner_exam', 'The location of a house or building.', 'address', 'Please write your name and *address* on the form.'),
(62, 'beginner_exam', 'To keep things apart or divide them.', 'separate', 'We need to *separate* the blue clothes from the white.'),
(63, 'beginner_exam', 'A reply to a question.', 'answer', 'He wrote his *answer* clearly on the paper.'),
(64, 'beginner_exam', 'A place full of books to borrow.', 'library', 'She likes to study at the public *library*.'),
(65, 'beginner_exam', 'Happening near the beginning of a time period.', 'early', 'We woke up *early* to catch the sunrise.'),
(66, 'beginner_exam', 'Not the same.', 'different', 'Each flower in the garden was a *different* color.'),
(67, 'beginner_exam', 'At all times; every time.', 'always', 'I *always* remember to brush my teeth before bed.'),
(68, 'intermediate', 'A great accomplishment or successful result gained through effort, using the \"ei\" spelling.', 'achievement', 'Winning the chess tournament was his greatest *achievement*.'),
(69, 'intermediate', 'Something that is obvious or clearly visible; easily understood.', 'apparent', 'It was immediately *apparent* that the lights were off in the house.'),
(70, 'intermediate', '../AUDIOS/Spelling/Intermediate/pronunciation_en_argument.mp3', 'argument', 'They had a heated *argument* about which movie to watch.'),
(71, 'intermediate', 'To be awake or aware of one\'s surroundings, often misspelled with an extra \"s\".', 'conscious', 'She was barely *conscious* after the long flight.'),
(72, 'intermediate', '../AUDIOS/Spelling/Intermediate/pronunciation_en_definitely.mp3', 'definitely', 'I will *definitely* finish this assignment before the deadline.'),
(73, 'intermediate', 'To feel shame, awkwardness, or humiliation, requiring both a double \"r\" and a double \"s\".', 'embarrass', 'He tried to hide his face so as not to *embarrass* his parents.'),
(74, 'intermediate', 'The surroundings or conditions in which a person, animal, or plant lives or operates, often missing the silent \"n\" in the middle.', 'environment', 'Protecting the natural *environment* is crucial for our future.'),
(75, 'intermediate', 'Belonging to a different country or nation, featuring the \"ei\" spelling and a silent \"g\".', 'foreign', 'He learned to speak a *foreign* language fluently.'),
(76, 'intermediate', '../AUDIOS/Spelling/Intermediate/pronunciation_en_guarantee.mp3', 'guarantee', 'The company provides a one-year *guarantee* against defects.'),
(77, 'intermediate', 'Right away; at once; without any delay, featuring a double \"m\".', 'immediately', 'The ambulance arrived *immediately* after the call.'),
(78, 'intermediate', 'Free from outside control; not depending on another for livelihood or authority.', 'independent', 'After college, she decided to live an *independent* life.'),
(79, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_maintenance.mp3', 'maintenance', 'The building requires regular *maintenance* to stay in good shape.'),
(80, 'intermediate', 'Required to be done, achieved, or present; essential, featuring one \"c\" and two \"s\"s.', 'necessary', 'A passport is *necessary* for international travel.'),
(81, 'intermediate', 'A particular time or instance of an event, often involving a special celebration, featuring a double \"c\" and a single \"s\".', 'occasion', 'The wedding was a joyous *occasion* for the whole family.'),
(82, 'intermediate', '../AUDIOS/Spelling/Intermediate/pronunciation_en_perseverance.mp3', 'perseverance', 'His *perseverance* eventually led him to achieve his goals.'),
(83, 'intermediate', 'The people employed in an organization, often involving a tricky double letter in the middle.', 'personnel', 'The company\'s *personnel* department handles all hiring.'),
(84, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_playwright.mp3', 'playwright', 'Shakespeare is known as the greatest English *playwright*.'),
(85, 'intermediate', 'To have or own something, featuring a double \"s\" in the middle.', 'possess', 'He claims to *possess* a rare collection of stamps.'),
(86, 'intermediate', 'To come before something in time or position.', 'precede', 'The introduction will *precede* the main chapter of the book.'),
(87, 'intermediate', 'The action of mentioning or alluding to something, or providing a source, often misspelled with an \"a\" in the second syllable.', 'reference', 'Please include a *reference* list at the end of your essay.'),
(88, 'intermediate', 'To divide or keep apart from one another, often misspelled with \"e\" instead of the middle \"a\".', 'separate', 'They decided to *separate* the white laundry from the colored laundry.'),
(89, 'intermediate', 'The accomplishment of an aim or purpose, featuring both a double \"c\" and a double \"s\".', 'success', 'Dedication is the key to lasting *success*.'),
(90, 'beginner', 'An unexpected event or piece of information, often misspelled by missing the first \"r\".', 'surprise', 'The party was a complete *surprise* for her birthday.'),
(91, 'intermediate', 'Moving in one side and out the other side of an opening, often confused with \"though\" or \"thorough\".', 'through', 'The train traveled *through* the long, dark tunnel.'),
(92, 'intermediate', 'Not anticipated or predicted.', 'unforeseen', 'Due to *unforeseen* circumstances, the meeting was canceled.'),
(93, 'beginner', 'The state of the atmosphere (rain, wind, temperature) at a particular time and place, often confused with the word for \"whether\".', 'weather', 'The cold *weather* made us stay inside.'),
(94, 'beginner', 'The fourth day of the week, featuring a silent \"d\".', 'wednesday', 'The team meets every *Wednesday* morning.'),
(95, 'intermediate', '../AUDIOS/Spelling/Intermediate/pronunciation_en_acquire.mp3', 'acquire', 'She is working hard to *acquire* new management skills.'),
(96, 'beginner', 'To fail to fulfill the expectations or hopes of someone, often misspelled with only one \"p\".', 'disappoint', 'I hope I don\'t *disappoint* my coach at the finals.'),
(97, 'beginner', 'A chart or series of pages showing the days, weeks, and months of a particular year, ending in \"ar\".', 'calendar', 'I marked the important dates on my new desk *calendar*.'),
(98, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_schedule.mp3', 'schedule', 'I need to check my work *schedule* for next week.'),
(99, 'beginner', 'Information, understanding, or skill that you get from experience or education, featuring a silent \"k\".', 'knowledge', 'The librarian had a vast amount of *knowledge* about ancient history.'),
(100, 'beginner', 'Personal ornaments, such as necklaces or rings, often misspelled by swapping the \"e\" and \"l\" order.', 'jewelry', 'She wore a beautiful silver *jewelry* set.'),
(101, 'intermediate', 'A special right, advantage, or immunity granted or available only to a particular person or group, often containing only one \"i\" and two \"e\"s.', 'privilege', 'It is a *privilege* to attend this exclusive university.'),
(102, 'beginner', 'An establishment where meals are prepared and served to customers, featuring a tricky silent \"u\" after the first three letters.', 'restaurant', 'We decided to try the new Italian *restaurant* downtown.'),
(103, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_bureaucracy.mp3', 'bureaucracy', 'The company was hampered by too much internal *bureaucracy*.'),
(104, 'intermediate', 'A situation in which a difficult choice has to be made between two or more alternatives, featuring a double \"m\".', 'dilemma', 'He faced a serious ethical *dilemma* about revealing the secret.'),
(105, 'intermediate', 'Extremely interesting or captivating, featuring the tricky \"sc\" combination.', 'fascinating', 'The documentary about space exploration was absolutely *fascinating*.'),
(106, 'intermediate', 'Feeling or showing an appreciation of kindness or favors received, often misspelled by using the word \"great\" as the first part.', 'grateful', 'I am very *grateful* for your assistance with the move.'),
(107, 'intermediate', 'Causing laughter and amusement; funny, often misspelled by missing an \"o\" after the \"r\".', 'humorous', 'His presentation was surprisingly *humorous* and engaging.'),
(108, 'intermediate', 'To give a vaccine to create immunity against a disease, featuring only a single \"n\".', 'inoculate', 'The doctor recommended we *inoculate* the children against the flu.'),
(109, 'intermediate', 'Too attractive and tempting to be resisted, often missing a double \"r\" or incorrect vowels in the second half.', 'irresistible', 'The warm chocolate chip cookies were utterly *irresistible*.'),
(110, 'intermediate', 'Causing or showing naughtiness, often misspelled with an extra vowel sound.', 'mischievous', 'The little boy had a *mischievous* glint in his eyes.'),
(111, 'intermediate', 'The highest legislature in a country, often containing a tricky silent letter.', 'parliament', 'The members of *parliament* debated the new law.'),
(112, 'intermediate', 'A line or sequence of people or vehicles awaiting their turn for something, featuring four silent letters at the end.', 'queue', 'We had to stand in a long *queue* to buy the concert tickets.'),
(113, 'intermediate', 'A strong, regular repeated pattern of movement or sound, often containing two silent letters.', 'rhythm', 'She clapped her hands to the *rhythm* of the music.'),
(114, 'intermediate', 'A supreme ruler, especially a monarch, featuring the \"ei\" spelling and often misspelled due to its pronunciation.', 'sovereign', 'The *sovereign* addressed the nation on the holiday.'),
(115, 'intermediate', 'To take the place of or replace another.', 'supersede', 'The new rules will *supersede* all previous regulations.'),
(116, 'intermediate', 'An empty space, featuring a tricky double \"u\".', 'vacuum', 'She used the *vacuum* cleaner to tidy the floor.'),
(117, 'intermediate', 'Exposed to the possibility of being attacked or harmed, either physically or emotionally.', 'vulnerable', 'Small children are particularly *vulnerable* to infections.'),
(118, 'intermediate', 'To ask for or request something formally and respectfully.', 'solicit', 'The charity will *solicit* donations in the town square.'),
(119, 'intermediate', 'An exact copy, often confused with \"exactitude\".', 'accurate', 'The clock displays the time with extreme *accurate*.'),
(120, 'intermediate', 'To make things better or more acceptable; to edit, often confused with \"amend\".', 'ameliorate', 'They hoped the new policies would *ameliorate* the housing shortage.'),
(121, 'intermediate', 'A place or thing where something is stored or kept, often misspelled with an \"e\".', 'repository', 'All the old records are kept in the digital *repository*.'),
(122, 'intermediate', 'A period of ten years.', 'decade', 'The last *decade* saw huge changes in technology.'),
(123, 'intermediate', 'To cause great surprise or wonder; to shock or astound.', 'astonish', 'His sudden success *astonish*ed everyone who knew him.'),
(124, 'intermediate', 'To receive or take in information or ideas, often misspelled with an extra \"b\".', 'absorb', 'The sponge can *absorb* a large amount of water.'),
(125, 'intermediate', 'To give an account of something; to relate or narrate.', 'describe', 'She was asked to *describe* the events of the accident.'),
(126, 'intermediate', 'In a quiet or unnoticeable way; secretly.', 'stealthily', 'The cat *stealthily* crept up on the mouse.'),
(127, 'intermediate', 'Relating to a particular area or community.', 'local', 'We prefer to buy our vegetables from *local* farms.'),
(128, 'intermediate', 'The opposite of private, available to all.', 'public', 'The park is a *public* space for everyone to enjoy.'),
(129, 'intermediate', 'A tendency to behave in a particular way; a preference.', 'predilection', 'He has a strong *predilection* for classical music.'),
(130, 'intermediate', 'A formal expression of praise, often confused with \"complement\".', 'compliment', 'He paid her a sincere *compliment* on her presentation.'),
(131, 'intermediate', 'A substance consisting of two or more different elements chemically bonded together.', 'compound', 'Water is a *compound* of hydrogen and oxygen.'),
(132, 'intermediate', 'A difference or disagreement, often about money.', 'discrepancy', 'There was a large *discrepancy* between the two reports.'),
(133, 'intermediate', 'Feeling or showing deep respect or reverence.', 'reverent', 'The worshipers spoke in a *reverent* whisper.'),
(134, 'intermediate', 'The quality of being easily seen or noticed.', 'visibility', 'The fog reduced road *visibility* to almost zero.'),
(135, 'intermediate', 'To make something better or more beautiful.', 'beautify', 'They hired a landscaping company to *beautify* the yard.'),
(136, 'intermediate', 'To speak or behave in a way that suggests a feeling of superiority.', 'condescend', 'Please don\'t *condescend* to me; I understand the concept.'),
(137, 'intermediate', 'Existing or occurring at the same time.', 'simultaneous', 'The two events happened in a *simultaneous* fashion.'),
(138, 'intermediate', 'A subtle difference in meaning, expression, or sound.', 'nuance', 'The artist captured every *nuance* of the sunset colors.'),
(139, 'beginner', 'A word used to explain a reason or cause for something.', 'because', 'We stayed home *because* it was raining outside.'),
(140, 'beginner', 'A person whom one knows and with whom one has a bond of mutual affection, featuring \"ie\".', 'friend', 'My *friend* and I played games all afternoon.'),
(141, 'beginner', 'The possessive form of \"they\", showing ownership.', 'their', '*Their* new car is very fast.'),
(142, 'beginner', 'A portion of an object or a fragment, often confused with a food-related word.', 'piece', 'He ate a small *piece* of cake.'),
(143, 'beginner', 'Certain or guaranteed; feeling no doubt.', 'sure', 'Are you *sure* you locked the door?'),
(144, 'beginner', 'To possess information, facts, or understanding, featuring a silent \"k\".', 'know', 'I *know* the answer to that question.'),
(145, 'beginner', 'To form letters or words on a surface with a pen or pencil, featuring a silent \"w\".', 'write', 'Please *write* your name on the line.'),
(146, 'beginner', 'The past tense of \"say\"; to utter words.', 'said', 'The teacher *said* we could go outside now.'),
(147, 'beginner', 'A word used to ask a question about choice or options.', 'which', '*Which* color do you prefer?'),
(148, 'beginner', 'The past tense of \"will\", used to express a polite request or possibility.', 'would', 'I *would* like to order the soup, please.'),
(149, 'beginner', 'A sudden, rough expulsion of air from the lungs, featuring a tricky \"gh\" spelling.', 'cough', 'He had a terrible *cough* after catching a cold.'),
(150, 'beginner', 'Having a bumpy or uneven surface; not smooth.', 'rough', 'The dog has very *rough* fur.'),
(151, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_half.mp3', 'half', 'I only ate *half* of my sandwich.'),
(152, 'beginner', 'To move at a regular and fairly slow pace by lifting and setting down each foot in turn, featuring a silent \"l\".', 'walk', 'Let\'s *walk* to the park this afternoon.'),
(153, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_often.mp3', 'often', 'We *often* visit my grandparents on Sundays.'),
(154, 'beginner', 'To perceive sound with the ear.', 'hear', 'Can you *hear* the music playing next door?'),
(155, 'beginner', 'The third person singular present tense of the verb \"do\".', 'does', 'She *does* her homework right after school.'),
(156, 'beginner', 'A large number of; referring to quantity.', 'many', 'There are *many* books on the shelf.'),
(157, 'beginner', 'Attractive in a delicate way, or fairly/moderately, featuring a double \"t\".', 'pretty', 'She bought a *pretty* dress for the party.'),
(158, 'beginner', 'Actively engaged in work or a pursuit; occupied, often confused with a similar-sounding word.', 'busy', 'I was too *busy* to answer the phone.'),
(159, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_build.mp3', 'build', 'They plan to *build* a new house next year.'),
(160, 'beginner', 'As much or as many as required, featuring the tricky \"gh\" spelling.', 'enough', 'Do we have *enough* milk for the recipe?'),
(161, 'beginner', 'An adjective for something you like the most.', 'favorite', 'Pizza is my *favorite* food.'),
(162, 'beginner', 'Something better than just \"good\".', 'great', 'That was a *great* movie!'),
(163, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_heart.mp3', 'heart', 'My *heart* beats faster when I run.'),
(164, 'beginner', 'A piece of land surrounded by water, featuring a silent \"s\".', 'island', 'They spent their vacation on a tropical *island*.'),
(165, 'beginner', 'To give one\'s attention to sound, featuring a silent \"t\".', 'listen', 'Please *listen* carefully to the instructions.'),
(166, 'beginner', 'A period of time equal to sixty seconds.', 'minute', 'The bus will arrive in one *minute*.'),
(167, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_ocean.mp3', 'ocean', 'They watched the waves crash on the *ocean* shore.'),
(168, 'beginner', 'It makes things sweet, made from sugarcane.', 'sugar', 'I put a spoonful of *sugar* in my coffee.'),
(169, 'beginner', 'It refers to something as not ordinary.', 'special', 'Today is a *special* day because it\'s my birthday.'),
(170, 'beginner', 'In a truthful and sincere manner, featuring a missing final \"e\" before \"-ly\".', 'truly', 'I am *truly* sorry for what happened.'),
(171, 'beginner', 'Difficulty or problems; annoyance or difficulty.', 'trouble', 'He got into *trouble* for being late.'),
(172, 'beginner', 'The day after today, featuring a double \"m\" and a double \"r\".', 'tomorrow', 'We are going to the zoo *tomorrow*.'),
(173, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_beautiful.mp3', 'beautiful', 'The sunset was absolutely *beautiful*.'),
(174, 'beginner', 'Items worn on the body, featuring a silent \"e\".', 'clothes', 'I need to wash my dirty *clothes*.'),
(175, 'beginner', 'The child of one\'s aunt or uncle.', 'cousin', 'My *cousin* came to visit for the holidays.'),
(176, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_early.mp3', 'early', 'We woke up *early* to watch the sunrise.'),
(177, 'beginner', 'The measurement of someone or something from head to foot.', 'height', 'They measured the *height* of the wall.'),
(178, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_lose.mp3', 'lose', 'Be careful not to *lose* your keys.'),
(179, 'beginner', 'Making little or no noise.', 'quiet', 'Please be *quiet* in the library.'),
(180, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_straight.mp3', 'straight', 'Draw a *straight* line across the paper.'),
(181, 'beginner', 'The mobile muscular organ in the mouth, featuring the tricky \"gue\" ending.', 'tongue', 'She burned her *tongue* on the hot tea.'),
(182, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_yacht.mp3', 'yacht', 'He dreamed of sailing a luxurious *yacht*.'),
(183, 'beginner', 'The number after seven.', 'eight', 'I need to buy *eight* apples from the store.'),
(184, 'beginner', 'The number 40, often misspelled by including a \"u\".', 'forty', 'My mother is *forty* years old.'),
(185, 'beginner', 'A building or room containing collections of books.', 'library', 'I borrowed three books from the *library*.'),
(186, 'beginner', 'An institution for educating children.', 'school', 'My *school* starts at 8 in the morning.'),
(187, 'beginner', 'The organ in the body where the digestion of food begins, featuring a silent \"ch\".', 'stomach', 'I have a pain in my *stomach*.'),
(188, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_against.mp3', 'against', 'He leaned his bike *against* the wall.'),
(189, 'beginner', 'The person who has control over others, featuring the \"aster\" spelling.', 'master', 'The dog obeyed his *master* immediately.'),
(190, 'beginner', 'In or to this place or position, often confused with the hearing word.', 'here', 'Come and sit right *here*.'),
(191, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_should.mp3', 'should', 'You *should* finish your homework before watching TV.'),
(192, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_show.mp3', 'show', 'Can you *show* me how to do that math problem?'),
(193, 'beginner', 'Small in amount or degree; not much.', 'little', 'I only ate a *little* bit of my dinner.'),
(194, 'beginner', 'The most common English greeting, casually just said as \"hi\".', 'hello', 'She waved and said *hello* to her neighbor.'),
(195, 'beginner', 'It means what cones next, like before and...', 'after', 'We will go to the park *after* lunch.'),
(196, 'beginner', 'A long, heavy piece of wood used in building or as a support, or something to write on when combined with \"black\" or \"white\".', 'board', 'The carpenter cut the *board* into two pieces.'),
(197, 'beginner', 'Able to be seen clearly; not cloudy, featuring the \"ea\" spelling.', 'clear', 'The water in the lake was crystal *clear*.'),
(198, 'beginner', 'To have knowledge of the qualities of something or someone.', 'familiar', 'That song sounds *familiar* to me.'),
(199, 'beginner', 'Meaning complete, or totally.', 'whole', 'He ate the *whole* sandwich.'),
(200, 'intermediate', 'To put money or something valuable into a place where it can be retrieved, featuring the \"i\" instead of \"e\".', 'deposit', 'I need to *deposit* my paycheck at the bank.'),
(201, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_believe.mp3', 'believe', 'I *believe* in being kind to everyone.'),
(202, 'beginner', 'To be suitable or correct for the situation.', 'appropriate', 'Wear clothing that is *appropriate* for the weather.'),
(203, 'beginner', '../AUDIOS/Spelling/Beginner/pronunciation_en_yield.mp3', 'yield', 'The farm had a good corn *yield* this year.'),
(204, 'intermediate', '../AUDIOS/Spelling/Beginner/pronunciation_en_zealous.mp3', 'zealous', 'The *zealous* student finished the project early.'),
(205, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_acquiesce.mp3', 'acquiesce', 'The committee needed time to *acquiesce* to the unexpected terms of the contract.'),
(206, 'advanced', 'To confess or acknowledge something reluctantly, typically because one is forced to, featuring a silent \"sh\" sound.', 'shriek', 'The old hinges would *shriek* whenever the door was opened.'),
(207, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_conscientious.mp3', 'conscientious', 'She is a *conscientious* employee who always puts in extra effort.'),
(208, 'advanced', 'A difference or contrast between two things that are or are represented as being opposed or entirely different.', 'dichotomy', 'The presentation explored the *dichotomy* between the marketing team and the engineering team.'),
(209, 'advanced', 'To make things worse; to inflame a conflict, problem, or bad situation.', 'exacerbate', 'His refusal to apologize only served to *exacerbate* the dispute.'),
(210, 'advanced', 'A distinctive or peculiar feature or characteristic of a person or thing.', 'idiosyncrasy', 'One of the manager\'s *idiosyncrasies* is starting every meeting exactly seven minutes late.'),
(211, 'advanced', 'Communication or cooperation which facilitates a close working relationship between people or organizations, featuring a tricky \"iai\" and a silent \"s\".', 'liaison', 'She serves as the main *liaison* between the local branch and the headquarters.'),
(212, 'advanced', 'A system such as a pattern of letters or associations that assists in remembering something, featuring a silent \"m\" at the start.', 'mnemonic', 'The professor taught us a useful *mnemonic* for remembering the geological eras.'),
(213, 'advanced', 'A typical example or pattern of something; a model, featuring a silent \"g\" in the middle.', 'paradigm', 'The introduction of cloud computing created a *paradigm* shift in IT infrastructure.'),
(214, 'advanced', 'A long, heavy piece of cloth hung as a decoration or to divide a room, featuring a double \"r\".', 'drapery', 'The heavy velvet *drapery* blocked out all the morning light.'),
(215, 'advanced', 'Not anticipated or predicted; happening by accident, featuring the tricky \"vertently\" ending.', 'inadvertently', 'I *inadvertently* deleted the file when I meant to save it.'),
(216, 'advanced', 'To accept the legitimacy or existence of something; to give official approval to.', 'acknowledge', 'The CEO needed to officially *acknowledge* the receipt of the resignation letter.'),
(217, 'advanced', 'The study or use of methods for storing, retrieving, and analyzing data.', 'statistics', 'The analyst specialized in interpreting market *statistics* and trends.'),
(218, 'advanced', 'A feeling of happiness, especially great or ecstatic joy.', 'ecstasy', 'The crowd cried out in *ecstasy* when the band finally took the stage.'),
(219, 'advanced', 'Having authority or power over all others; supreme, featuring the tricky \"ei\" and a silent \"g\".', 'sovereignty', 'The issue of national *sovereignty* was a key point of the political debate.'),
(220, 'advanced', 'A member of a government bureaucracy, often associated with excessive rules.', 'bureaucrat', 'He complained that the local *bureaucrat* refused to process his forms.'),
(221, 'advanced', 'To work together, especially on a literary or scientific endeavor, featuring a double \"l\" and a double \"b\".', 'collaborate', 'Our departments decided to *collaborate* on the upcoming advertising campaign.'),
(222, 'advanced', 'A person who is guided by reason, good sense, and practical considerations, featuring the \"gmat\" structure.', 'pragmatist', 'In a crisis, it\'s better to be a *pragmatist* than an idealist.'),
(223, 'advanced', 'Something that deviates from what is standard, normal, or expected, featuring only one \"n\".', 'anomaly', 'The sudden dip in sales was treated as a statistical *anomaly*.'),
(224, 'advanced', 'In a way that deviates from the normal or expected, featuring a double \"z\".', 'bizarre', 'She told us a truly *bizarre* story about her trip to the desert.'),
(225, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_equivocate.mp3', 'equivocate', 'When questioned about the budget cuts, the politician tried to *equivocate*.'),
(226, 'advanced', 'Relating to money or the management of government revenue, featuring a silent \"sc\".', 'fiscal', 'The company is preparing its *fiscal* report for the final quarter.'),
(227, 'advanced', 'A statement, often used in debate, that expresses the opposite of a conclusion.', 'antithesis', 'War is the *antithesis* of peace.'),
(228, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_facilitate.mp3', 'facilitate', 'The team leader\'s job is to *facilitate* communication among all members.'),
(229, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_harass.mp3', 'harass', 'We were asked never to *harass* other employees about their personal choices.'),
(230, 'advanced', 'A system or organization in which people or groups are ranked one above the other according to status or authority.', 'hierarchy', 'She quickly moved up the corporate *hierarchy* due to her skill.'),
(231, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_clerical.mp3', 'clerical', 'His new job involved mostly *clerical* and administrative duties.'),
(232, 'advanced', 'The act of making a formal request for something.', 'inquiry', 'We received an *inquiry* from a potential investor this morning.'),
(233, 'advanced', 'To be judged, or the noun after something has been judged. Tricky US-UK spelling difference.', 'judgment', 'The board questioned his poor *judgment* regarding the project risk.'),
(234, 'advanced', 'To move or operate freely or strategically in a space, featuring the tricky \"oeu\".', 'maneuver', 'The driver executed a difficult *maneuver* to avoid hitting the debris.'),
(235, 'advanced', 'Below the required, necessary, or proper standard; poor quality, featuring a tricky \"io\" vowel combination.', 'mediocre', 'The customer complained that the service was disappointingly *mediocre*.'),
(236, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_meticulous.mp3', 'meticulous', 'The accountant was always *meticulous* about checking every number.'),
(237, 'advanced', 'A deputy or substitute acting for a superior, featuring the tricky \"lieu\" start.', 'lieutenant', 'The sales *lieutenant* took charge while the director was on leave.'),
(238, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_quintessence.mp3', 'quintessence', 'The veteran worker was the *quintessence* of dedication and experience.'),
(239, 'advanced', 'To have knowledge of everything; all-knowing, featuring a silent \"sc\".', 'omniscient', 'The novelist chose an *omniscient* point of view for the story narration.'),
(240, 'advanced', 'Side by side and having the same distance continuously between them, featuring a double \"l\" in the middle, and single \"l\" at the end.', 'parallel', 'The two design teams worked on *parallel* projects for several months.'),
(241, 'advanced', 'A complex sequence of questions, featuring a double \"n\" and a tricky ending.', 'questionnaire', 'We distributed a detailed *questionnaire* to gather customer feedback.'),
(242, 'advanced', 'To advise or suggest strongly, featuring a single \"c\" and double \"m\".', 'recommend', 'I strongly *recommend* that you review the entire contract before signing.'),
(243, 'advanced', 'A meeting arranged for a specific time and place, taken from French.', 'rendezvous', 'The project team will *rendezvous* in the conference room at noon.'),
(244, 'advanced', 'The ability to recover quickly from difficulties, featuring a tricky \"ce\" ending.', 'resilience', 'The company showed great *resilience* in adapting to the sudden market changes.'),
(245, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_subpoena.mp3', 'subpoena', 'The CEO received a *subpoena* requiring him to produce internal documents.'),
(246, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_eulogy.mp3', 'eulogy', 'The manager delivered a moving *eulogy* at the retirement dinner.'),
(247, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_ubiquitous.mp3', 'ubiquitous', 'Access to high-speed internet is nearly *ubiquitous* in this neighborhood.'),
(248, 'advanced', 'Having to do with the sense of smell, featuring a tricky \"lfact\" sequence.', 'olfactory', 'The chemist used his keen *olfactory* sense to identify the unknown substance.'),
(249, 'advanced', 'To make a problem less severe or serious.', 'alleviate', 'New road construction is planned to *alleviate* the morning traffic congestion.'),
(250, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_sojourn.mp3', 'sojourn', 'She took a brief *sojourn* to the mountains to clear her head before the big project.'),
(251, 'advanced', 'An apparatus or room for preserving food or other substances at a low temperature.', 'refrigerator', 'We need to clear out the old food from the office *refrigerator*.'),
(252, 'advanced', 'Existing or occurring at the same time, featuring the \"simul\" root.', 'simultaneous', 'The system supports *simultaneous* logins from multiple devices.'),
(253, 'advanced', '../AUDIOS/Spelling/Advanced/pronunciation_en_elucidate.mp3', 'elucidate', 'Can you *elucidate* your earlier point about the budget cuts?'),
(254, 'advanced', 'A fictitious name, especially one used by an author, featuring a silent \"p\" at the start.', 'pseudonym', 'The whistleblower published the report under a secure *pseudonym*.'),
(255, 'advanced', 'The measurement of something from side to side; breadth, featuring a silent \"d\".', 'width', 'We need to check the exact *width* of the delivery entrance.'),
(256, 'advanced', 'Not intended; done or happening by accident, featuring \"cid\" sequence.', 'coincidence', 'Running into my old boss in a new city was a strange *coincidence*.'),
(257, 'advanced', 'To be required as a duty or necessity, featuring the \"lig\" sequence.', 'obligate', 'The contract terms *obligate* the company to provide training.'),
(258, 'advanced', 'A person who studies rocks and the structure of the earth.', 'geologist', 'The *geologist* examined the rock samples for signs of oil.'),
(259, 'intermediate_exam', 'A great accomplishment or successful result gained through effort, using the \"ei\" spelling.', 'achievement', 'Winning the chess tournament was his greatest *achievement*.'),
(260, 'intermediate_exam', 'Something that is obvious or clearly visible; easily understood.', 'apparent', 'It was immediately *apparent* that the lights were off in the house.'),
(261, 'intermediate_exam', 'Usually referring to a quarrel. Tricky UK-US spelling difference.', 'argument', 'They had a heated *argument* about which movie to watch.'),
(262, 'intermediate_exam', 'To be awake or aware of one\'s surroundings, often misspelled with an extra \"s\".', 'conscious', 'She was barely *conscious* after the long flight.'),
(263, 'intermediate_exam', 'Without a doubt; surely; used to emphasize that something is true.', 'definitely', 'I will *definitely* finish this assignment before the deadline.'),
(264, 'intermediate_exam', 'To feel shame, awkwardness, or humiliation, requiring both a double \"r\" and a double \"s\".', 'embarrass', 'He tried to hide his face so as not to *embarrass* his parents.'),
(265, 'intermediate_exam', 'The surroundings or conditions in which a person, animal, or plant lives or operates, often missing the silent \"n\" in the middle.', 'environment', 'Protecting the natural *environment* is crucial for our future.'),
(266, 'intermediate_exam', 'Belonging to a different country or nation, featuring the \"ei\" spelling and a silent \"g\".', 'foreign', 'He learned to speak a *foreign* language fluently.'),
(267, 'intermediate_exam', 'A formal promise or assurance that certain conditions will be fulfilled, especially for a product, featuring two \"e\"s at the end.', 'guarantee', 'The company provides a one-year *guarantee* against defects.'),
(268, 'intermediate_exam', 'Right away; at once; without any delay, featuring a double \"m\".', 'immediately', 'The ambulance arrived *immediately* after the call.'),
(269, 'intermediate_exam', 'Free from outside control; not depending on another for livelihood or authority.', 'independent', 'After college, she decided to live an *independent* life.'),
(270, 'intermediate_exam', 'The process of preserving a condition or state of repair, often misspelled with \"e\" instead of the second \"a\".', 'maintenance', 'The building requires regular *maintenance* to stay in good shape.'),
(271, 'intermediate_exam', 'Required to be done, achieved, or present; essential, featuring one \"c\" and two \"s\"s.', 'necessary', 'A passport is *necessary* for international travel.'),
(272, 'intermediate_exam', 'A particular time or instance of an event, often involving a special celebration, featuring a double \"c\" and a single \"s\".', 'occasion', 'The wedding was a joyous *occasion* for the whole family.'),
(273, 'intermediate_exam', 'Persistence in doing something despite difficulty or delay in achieving success, often involving incorrect vowels in the third syllable.', 'perseverance', 'His *perseverance* eventually led him to achieve his goals.'),
(274, 'intermediate_exam', 'The people employed in an organization, often involving a tricky double letter in the middle.', 'personnel', 'The company\'s *personnel* department handles all hiring.'),
(275, 'intermediate_exam', 'A person who writes scripts for plays, featuring a silent \"w\" in the second half.', 'playwright', 'Shakespeare is known as the greatest English *playwright*.'),
(276, 'intermediate_exam', 'To have or own something, featuring a double \"s\" in the middle.', 'possess', 'He claims to *possess* a rare collection of stamps.'),
(277, 'intermediate_exam', 'To come before something in time or position.', 'precede', 'The introduction will *precede* the main chapter of the book.'),
(278, 'intermediate_exam', 'The action of mentioning or alluding to something, or providing a source, often misspelled with an \"a\" in the second syllable.', 'reference', 'Please include a *reference* list at the end of your essay.'),
(279, 'intermediate_exam', 'To divide or keep apart from one another, often misspelled with \"e\" instead of the middle \"a\".', 'separate', 'They decided to *separate* the white laundry from the colored laundry.'),
(280, 'intermediate_exam', 'The accomplishment of an aim or purpose, featuring both a double \"c\" and a double \"s\".', 'success', 'Dedication is the key to lasting *success*.'),
(281, 'intermediate_exam', 'An unexpected event or piece of information, often misspelled by missing the first \"r\".', 'surprise', 'The party was a complete *surprise* for her birthday.'),
(282, 'intermediate_exam', 'Moving in one side and out the other side of an opening, often confused with \"though\" or \"thorough\".', 'through', 'The train traveled *through* the long, dark tunnel.'),
(283, 'intermediate_exam', 'Not anticipated or predicted.', 'unforeseen', 'Due to *unforeseen* circumstances, the meeting was canceled.'),
(284, 'intermediate_exam', 'The state of the atmosphere (rain, wind, temperature) at a particular time and place, often confused with the word for \"whether\".', 'weather', 'The cold *weather* made us stay inside.'),
(285, 'intermediate_exam', 'The fourth day of the week, featuring a silent \"d\".', 'Wednesday', 'The team meets every *Wednesday* morning.'),
(286, 'intermediate_exam', 'To buy or obtain a non-tangible asset or skill, often confused with \"require\".', 'acquire', 'She is working hard to *acquire* new management skills.'),
(287, 'intermediate_exam', 'To fail to fulfill the expectations or hopes of someone, often misspelled with only one \"p\".', 'disappoint', 'I hope I don\'t *disappoint* my coach at the finals.'),
(288, 'intermediate_exam', 'A chart or series of pages showing the days, weeks, and months of a particular year, ending in \"ar\".', 'calendar', 'I marked the important dates on my new desk *calendar*.'),
(289, 'intermediate_exam', 'A plan for performing a task or achieving an objective, particularly a timetable.', 'schedule', 'I need to check my work *schedule* for next week.'),
(290, 'intermediate_exam', 'Information, understanding, or skill that you get from experience or education, featuring a silent \"k\".', 'knowledge', 'The librarian had a vast amount of *knowledge* about ancient history.'),
(291, 'intermediate_exam', 'Personal ornaments, such as necklaces or rings, often misspelled by swapping the \"e\" and \"l\" order.', 'jewelry', 'She wore a beautiful silver *jewelry* set.'),
(292, 'intermediate_exam', 'A special right, advantage, or immunity granted or available only to a particular person or group, often containing only one \"i\" and two \"e\"s.', 'privilege', 'It is a *privilege* to attend this exclusive university.'),
(293, 'intermediate_exam', 'An establishment where meals are prepared and served to customers, featuring a tricky silent \"u\" after the first three letters.', 'restaurant', 'We decided to try the new Italian *restaurant* downtown.'),
(294, 'intermediate_exam', 'A system of government or administration marked by excessive complexity and rules.', 'bureaucracy', 'The company was hampered by too much internal *bureaucracy*.'),
(295, 'intermediate_exam', 'A situation in which a difficult choice has to be made between two or more alternatives, featuring a double \"m\".', 'dilemma', 'He faced a serious ethical *dilemma* about revealing the secret.'),
(296, 'intermediate_exam', 'Extremely interesting or captivating, featuring the tricky \"sc\" combination.', 'fascinating', 'The documentary about space exploration was absolutely *fascinating*.'),
(297, 'intermediate_exam', 'Feeling or showing an appreciation of kindness or favors received, often misspelled by using the word \"great\" as the first part.', 'grateful', 'I am very *grateful* for your assistance with the move.'),
(298, 'intermediate_exam', 'Causing laughter and amusement; funny, often misspelled by missing an \"o\" after the \"r\".', 'humorous', 'His presentation was surprisingly *humorous* and engaging.'),
(299, 'intermediate_exam', 'To give a vaccine to create immunity against a disease, featuring only a single \"n\".', 'inoculate', 'The doctor recommended we *inoculate* the children against the flu.'),
(300, 'intermediate_exam', 'Too attractive and tempting to be resisted, often missing a double \"r\" or incorrect vowels in the second half.', 'irresistible', 'The warm chocolate chip cookies were utterly *irresistible*.'),
(301, 'intermediate_exam', 'Causing or showing naughtiness, often misspelled with an extra vowel sound.', 'mischievous', 'The little boy had a *mischievous* glint in his eyes.'),
(302, 'intermediate_exam', 'The highest legislature in a country, often containing a tricky silent letter.', 'parliament', 'The members of *parliament* debated the new law.'),
(303, 'intermediate_exam', 'A line or sequence of people or vehicles awaiting their turn for something, featuring four silent letters at the end.', 'queue', 'We had to stand in a long *queue* to buy the concert tickets.'),
(304, 'intermediate_exam', 'A strong, regular repeated pattern of movement or sound, often containing two silent letters.', 'rhythm', 'She clapped her hands to the *rhythm* of the music.'),
(305, 'intermediate_exam', 'A supreme ruler, especially a monarch, featuring the \"ei\" spelling and often misspelled due to its pronunciation.', 'sovereign', 'The *sovereign* addressed the nation on the holiday.'),
(306, 'intermediate_exam', 'To take the place of or replace another.', 'supersede', 'The new rules will *supersede* all previous regulations.'),
(307, 'intermediate_exam', 'An empty space, featuring a tricky double \"u\".', 'vacuum', 'She used the *vacuum* cleaner to tidy the floor.'),
(308, 'intermediate_exam', 'Exposed to the possibility of being attacked or harmed, either physically or emotionally.', 'vulnerable', 'Small children are particularly *vulnerable* to infections.'),
(309, 'intermediate_exam', 'To ask for or request something formally and respectfully.', 'solicit', 'The charity will *solicit* donations in the town square.'),
(310, 'intermediate_exam', 'An exact copy, often confused with \"exactitude\".', 'accurate', 'The clock displays the time with extreme *accurate*.'),
(311, 'intermediate_exam', 'To make things better or more acceptable; to edit, often confused with \"amend\".', 'ameliorate', 'They hoped the new policies would *ameliorate* the housing shortage.'),
(312, 'intermediate_exam', 'A place or thing where something is stored or kept, often misspelled with an \"e\".', 'repository', 'All the old records are kept in the digital *repository*.'),
(313, 'intermediate_exam', 'A period of ten years.', 'decade', 'The last *decade* saw huge changes in technology.');
INSERT INTO `spelling` (`id`, `level`, `question`, `answer`, `info`) VALUES
(314, 'intermediate_exam', 'To cause great surprise or wonder; to shock or astound.', 'astonish', 'His sudden success *astonish*ed everyone who knew him.'),
(315, 'intermediate_exam', 'To receive or take in information or ideas, often misspelled with an extra \"b\".', 'absorb', 'The sponge can *absorb* a large amount of water.'),
(316, 'intermediate_exam', 'To give an account of something; to relate or narrate.', 'describe', 'She was asked to *describe* the events of the accident.'),
(317, 'intermediate_exam', 'In a quiet or unnoticeable way; secretly.', 'stealthily', 'The cat *stealthily* crept up on the mouse.'),
(318, 'intermediate_exam', 'Relating to a particular area or community.', 'local', 'We prefer to buy our vegetables from *local* farms.'),
(319, 'intermediate_exam', 'The opposite of private, available to all.', 'public', 'The park is a *public* space for everyone to enjoy.'),
(320, 'intermediate_exam', 'A tendency to behave in a particular way; a preference.', 'predilection', 'He has a strong *predilection* for classical music.'),
(321, 'intermediate_exam', 'A formal expression of praise, often confused with \"complement\".', 'compliment', 'He paid her a sincere *compliment* on her presentation.'),
(322, 'intermediate_exam', 'A substance consisting of two or more different elements chemically bonded together.', 'compound', 'Water is a *compound* of hydrogen and oxygen.'),
(323, 'intermediate_exam', 'A difference or disagreement, often about money.', 'discrepancy', 'There was a large *discrepancy* between the two reports.'),
(324, 'intermediate_exam', 'Feeling or showing deep respect or reverence.', 'reverent', 'The worshipers spoke in a *reverent* whisper.'),
(325, 'intermediate_exam', 'The quality of being easily seen or noticed.', 'visibility', 'The fog reduced road *visibility* to almost zero.'),
(326, 'intermediate_exam', 'To make something better or more beautiful.', 'beautify', 'They hired a landscaping company to *beautify* the yard.'),
(327, 'intermediate_exam', 'To speak or behave in a way that suggests a feeling of superiority.', 'condescend', 'Please don\'t *condescend* to me; I understand the concept.'),
(328, 'intermediate_exam', 'Existing or occurring at the same time.', 'simultaneous', 'The two events happened in a *simultaneous* fashion.'),
(329, 'intermediate_exam', 'A subtle difference in meaning, expression, or sound.', 'nuance', 'The artist captured every *nuance* of the sunset colors.'),
(330, 'advanced_exam', 'A temporary suspension of activity or progress', 'hiatus', 'The show went on a brief *hiatus* before returning in the fall.'),
(331, 'advanced_exam', 'Describes something that cannot be heard', 'inaudible', 'Her whisper was almost *inaudible* over the noise.'),
(332, 'advanced_exam', 'Means a tendency to do something repeatedly', 'propensity', 'He has a *propensity* for arriving late.'),
(333, 'advanced_exam', 'Means extremely careful and precise', 'meticulous', 'She kept *meticulous* records of every transaction.'),
(334, 'advanced_exam', 'A person who supports a cause or policy', 'advocate', 'She is an *advocate* for environmental reform.'),
(335, 'advanced_exam', 'Means easily believing things without sufficient evidence', 'gullible', 'Only the most *gullible* would fall for that scam.'),
(336, 'advanced_exam', 'Means difficult to understand; obscure', 'esoteric', 'The professor specialized in *esoteric* topics.'),
(337, 'advanced_exam', 'Means existing everywhere at once', 'ubiquitous', 'Smartphones have become *ubiquitous* in modern society.'),
(338, 'advanced_exam', 'Means capable of being shaped or bent', 'malleable', 'Gold is a very *malleable* metal.'),
(339, 'advanced_exam', 'Means feeling regret for wrongdoing', 'remorseful', 'He felt *remorseful* after realizing his mistake.'),
(340, 'advanced_exam', 'Means overly self-satisfied', 'complacent', 'The team grew *complacent* after several easy wins.'),
(341, 'advanced_exam', 'Means unpredictable and impulsive', 'capricious', 'Her *capricious* decisions made her hard to work with.'),
(342, 'advanced_exam', 'Means to make something worse', 'exacerbate', 'Adding insult to injury would only *exacerbate* the situation.'),
(343, 'advanced_exam', 'Means showing great knowledge or learning', 'erudite', 'The lecture was given by an *erudite* historian.'),
(344, 'advanced_exam', 'Means self-denying or austere', 'ascetic', 'The monk lived an *ascetic* life of simplicity.'),
(345, 'advanced_exam', 'Means using few words; concise', 'laconic', 'His *laconic* reply ended the conversation quickly.'),
(346, 'advanced_exam', 'Means peaceful and calm', 'serene', 'The lake looked *serene* under the moonlight.'),
(347, 'advanced_exam', 'Means very talkative', 'loquacious', 'He became *loquacious* after his third cup of coffee.'),
(348, 'advanced_exam', 'Means calm and composed under stress', 'imperturbable', 'She remained *imperturbable* despite the chaos.'),
(349, 'advanced_exam', 'Means full of energy and enthusiasm', 'ebullient', 'The crowd was *ebullient* after the victory.'),
(350, 'advanced_exam', 'Means stubbornly refusing to change opinion', 'obstinate', 'He was too *obstinate* to admit his error.'),
(351, 'advanced_exam', 'Means something that deviates from the norm', 'anomaly', 'His rapid recovery was an *anomaly*.'),
(352, 'advanced_exam', 'Means impossible to satisfy', 'insatiable', 'She had an *insatiable* appetite for adventure.'),
(353, 'advanced_exam', 'Means secret or hidden', 'clandestine', 'They held *clandestine* meetings in the old warehouse.'),
(354, 'advanced_exam', 'Means sharp or severe in effect', 'acute', 'She experienced *acute* pain in her shoulder.'),
(355, 'advanced_exam', 'Means deeply respectful', 'reverent', 'The audience fell *reverent* as the orchestra began.'),
(356, 'advanced_exam', 'Means showing great generosity', 'magnanimous', 'He was *magnanimous* in victory and gracious in defeat.'),
(357, 'advanced_exam', 'Means generous or forgiving', 'benevolent', 'A *benevolent* donor paid the students\' tuition.'),
(358, 'advanced_exam', 'Means extremely careful and exact', 'scrupulous', 'He was *scrupulous* about checking every detail.'),
(359, 'advanced_exam', 'Means short-lived or temporary', 'ephemeral', 'Youth is *ephemeral*, but memories last forever.'),
(360, 'advanced_exam', 'Means dull or uninspired writing or speech', 'prosaic', 'The speech was *prosaic* and failed to inspire.'),
(361, 'advanced_exam', 'Means expressing goodwill or kind feelings', 'amicable', 'They reached an *amicable* settlement after the dispute.'),
(362, 'advanced_exam', 'Means impossible to understand', 'incomprehensible', 'The accent made his words almost *incomprehensible*.'),
(363, 'advanced_exam', 'Means boldly disrespectful', 'insolent', 'The student\'s *insolent* tone offended the teacher.'),
(364, 'advanced_exam', 'Means able to recover quickly from difficulty', 'resilient', 'She remained *resilient* after multiple setbacks.'),
(365, 'advanced_exam', 'Means extremely attentive or eager to please', 'obsequious', 'The waiter was overly *obsequious*, which annoyed them.'),
(366, 'advanced_exam', 'Means uncertain or ambiguous', 'equivocal', 'His *equivocal* answer left everyone confused.'),
(367, 'advanced_exam', 'Means not harmful or gentle', 'benign', 'Fortunately, the tumor was *benign*.'),
(368, 'advanced_exam', 'Means arrogant or disdainful', 'supercilious', 'Her *supercilious* attitude made her unpopular.'),
(369, 'advanced_exam', 'Means wise or showing good judgment', 'sagacious', 'The *sagacious* leader foresaw the coming crisis.'),
(370, 'advanced_exam', 'Means deserving praise or reward', 'meritorious', 'Her *meritorious* service earned her a medal.'),
(371, 'advanced_exam', 'Means generous or freely giving', 'munificent', 'The charity benefited from a *munificent* donation.'),
(372, 'advanced_exam', 'Means lacking energy or enthusiasm', 'listless', 'He felt *listless* after staying up all night.'),
(373, 'advanced_exam', 'Means careful and persistent work or effort', 'diligent', 'She is a *diligent* student who never misses a deadline.'),
(374, 'advanced_exam', 'Means intended to teach a moral lesson', 'didactic', 'The novel was too *didactic* to be truly entertaining.'),
(375, 'advanced_exam', 'Means famous for a bad reason', 'notorious', 'The town was *notorious* for its corruption.'),
(376, 'advanced_exam', 'Means lazy or showing an avoidance of work', 'indolent', 'He became *indolent* after winning the lottery.'),
(377, 'advanced_exam', 'Means incapable of being corrected', 'incorrigible', 'Her *incorrigible* optimism was both charming and tiring.'),
(378, 'advanced_exam', 'Means impossible to stop or prevent', 'inexorable', 'Time moves forward with *inexorable* force.');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(10) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nickname` varchar(25) NOT NULL,
  `password` char(255) NOT NULL,
  `level` varchar(25) NOT NULL,
  `path_level` int(5) NOT NULL,
  `daily_level` int(5) NOT NULL,
  `streak` int(5) NOT NULL,
  `max_streak` int(5) NOT NULL,
  `played_today` tinyint(1) NOT NULL,
  `last_act` date NOT NULL,
  `spelling_stats` varchar(10) NOT NULL DEFAULT '0,0',
  `pronunciation_stats` varchar(10) NOT NULL DEFAULT '0,0',
  `grammar_stats` varchar(10) NOT NULL DEFAULT '0,0',
  `sent_form_stats` varchar(10) NOT NULL DEFAULT '0,0',
  `q_and_a_stats` varchar(10) NOT NULL DEFAULT '0,0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `nickname`, `password`, `level`, `path_level`, `daily_level`, `streak`, `max_streak`, `played_today`, `last_act`, `spelling_stats`, `pronunciation_stats`, `grammar_stats`, `sent_form_stats`, `q_and_a_stats`) VALUES
(1, 'testing@test.com', 'Test', '$2y$10$CscpRSpzUVUWSUDDSwKGHuhFaSJnEsJOvDK5jcYaSpCLxAQwRNIK2', 'advanced', 30, 0, 5, 5, 0, '2025-11-19', '26,2', '7,4', '6,23', '4,1', '4,2'),
(8, 'beginnertest@gmail.com', 'Beginner Test', '$2y$10$rqXuhorzNqH5DZBQOG/BfON.O4XE08AXUHwTKDv.3BuCAuN87To4C', 'beginner', 20, 0, 1, 5, 0, '2025-11-19', '29,64', '0,0', '26,16', '27,41', '0,0'),
(9, 'intermediatetest@test.com', 'Intermediateeeeeeeee', '$2y$10$OHIpm6NsXLWKy9CknJXshOQdxz.E4iLoWkhKDAcxocEpGUQy500uK', 'intermediate', 0, 2, 0, 0, 1, '2025-11-16', '17,19', '0,5', '11,1', '7,1', '0,0'),
(10, 'paiwgev@gmail.com', 'Oogwen', '$2y$10$pQ7z.NuOSAqy6EiodQTgLuXP8FPF91ubju3ULAkplyEyHwSp9gVIS', 'beginner', 0, 0, 0, 0, 0, '0000-00-00', '0,0', '0,0', '0,0', '0,0', '0,0'),
(11, 'test123@gmail.com', 'Beta', '$2y$10$oVF/VpoNLQNCRhAR6RTyCOlOKwE/r4IXjFL9Q6Egxbw6JHNk3vYaa', 'beginner', 0, 0, 0, 0, 0, '0000-00-00', '0,0', '0,0', '0,0', '0,0', '0,0'),
(14, 'changetest@c.com', 'change', '$2y$10$q336eoJFZF9fyjUZiaN2LOB4xknQhsgSOTtiS.Hj.cotRn4lAw.dq', 'beginner', 0, 0, 0, 0, 0, '0000-00-00', '0,0', '0,0', '0,0', '0,0', '0,0'),
(18, 'badatspelling@gmail.com', 'Bad Spelling', '$2y$10$uao8.ti.VOgVOQDCkQ4pl.TO5LVqcT6fMNlWBmy/n0lkAe1YUni5G', 'beginner', 1, 2, 0, 0, 1, '2025-11-19', '0,5', '0,0', '7,0', '7,2', '0,0'),
(19, 'paulquiliope0625@gmail.com', 'Tek', '$2y$10$4BHH/grU.VZ58y55qFvvuuEyGphVi0I34NnqqC0D3ol4NMT16RHmu', 'beginner', 0, 2, 0, 0, 1, '2025-11-17', '5,0', '0,0', '3,2', '5,0', '0,0'),
(21, 'among@among.among', 'among', '$2y$10$EXU5sQOZDjrZuMl8Ke8yRebk3l7Kb3xItoSGhQDVoAhc7QPv0AWWG', 'beginner', 1, 0, 0, 0, 0, '0000-00-00', '0,0', '0,0', '0,0', '0,0', '0,0'),
(24, 'test2@gmail.com', 'test', '$2y$10$vCEaOtBXkAZAIt2xRaCHfef1vtxR2x63M/wcPjBKamxfLXwtfCjK2', 'advanced', 1, 0, 0, 0, 0, '0000-00-00', '0,0', '0,0', '0,0', '0,0', '0,0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `grammar`
--
ALTER TABLE `grammar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `path_info`
--
ALTER TABLE `path_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pronunciation`
--
ALTER TABLE `pronunciation`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `q_and_a`
--
ALTER TABLE `q_and_a`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sentence_form`
--
ALTER TABLE `sentence_form`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `spelling`
--
ALTER TABLE `spelling`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `grammar`
--
ALTER TABLE `grammar`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=310;

--
-- AUTO_INCREMENT for table `path_info`
--
ALTER TABLE `path_info`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `pronunciation`
--
ALTER TABLE `pronunciation`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `q_and_a`
--
ALTER TABLE `q_and_a`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `sentence_form`
--
ALTER TABLE `sentence_form`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=421;

--
-- AUTO_INCREMENT for table `spelling`
--
ALTER TABLE `spelling`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=379;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
